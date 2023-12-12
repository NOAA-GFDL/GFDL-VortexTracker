Tim Marchok (timothy.marchok@noaa.gov)

NOAA / GFDL

12/5/2023

Some details on how the GFDL Vortex Tracker runs in genesis detection mode
--------------------------------------------------------------------------

Details on running my tracker in genesis mode are below. I did a lot of work
on upgrading the genesis detection & tracking capabilities of the tracker
earlier this year, for two purposes. First, the previous version ran like
a dog. I was able to identify a serious bottleneck in the code that searches
for new systems at each new lead time, and I rewrote that algorithm (doing
so reduced the runtime by greater than 99%). Second, the tracker diagnosed
too many false alarm TCs in the previous version. I added algorithms to
address this. As part of this, I consulted with NHC on what their methods
are for identifying genesis in observed storms, and to the extent possible
with model data, I created my modified algorithms to mimic what NHC does in
operations, in particular one for diagnosing a low-level wind circulation,
described below.

I'll first give a very short, high-level overview on how things work in the
tracker when run in genesis mode, then I'll go into more detail.

**_High-level overview:_** At a given lead time, the tracker first creates fix
positions for already-identified model storms that have already been tracked
at the previous lead time. Then an initial scan is done over the entire domain
in order to identify any new "candidate" systems at this lead time that might
be a cyclone. Then a full scan is done by applying the full set of tracking
criteria to these candidate storms to confirm whether a cyclone exists. If a
cyclone does exist, then the full set of tracker output is generated and a
guess position to begin the search for this storm at the next lead time
is calculated.

**_Algorithm details:_**

**Initial scan:**
- The purpose here is to simply identify "candidate" points that might be
cyclone centers. In order to expedite detection, I completely rewrote this
algorithm tomore efficiently scan over the domain. In addition, a land-sea
mask is employed to filter out land points. This filtering of land points is
only for TC genesis; of course, model TCs that have previously been tracked
over water are allowed to continue to be tracked over land. Also, any point
is filtered out that has an MSLP value higher than one standard deviation
above the mean MSLP in the domain.

- At each point in the domain that is scanned, the MSLP radial gradient is
evaluated at discrete distances along eight equally-spaced (every 45 degrees)
radial legs extending outward from 10 to 100 km. There is some fuzzy logic
that allows both for some amount of noise and also some amount of asymmetry
in the initial MSLP disturbance field, but in general, a point must maintain
an outward-sloping gradient over that 100-km distance and, critically, along
each radial leg there must be an MSLP depth at least equal to a value that
the user specifies in a namelist (I usually set it at 1 mb... anything larger
than that makes it more difficult to pass this check and therefore delays
the tracker-diagnosed time of genesis).

- Another key thing that I added with this most recent update is the ability
to smoothe the MSLP data prior to this initial scan. When using smoother,
coarser-resolution data such as 0.25-deg GFS or ECMWF data, that smoothing
isn't needed. But I found that when using this MSLP-checking scheme for
genesis detection on high-resolution data like our 3-km GFDL T-SHiELD model
data, those MSLP data were so noisy & variable that it was tripping up the
algorithm. So I added a multi-directional, 9-point smoother, and the user
specifies in a namelist whether or not to use that. This smoothing helped by
a tremendous amount for hi-res data!

- If the previous MSLP gradient check passes, then an additional check is done
to test for a cyclonic, low-level (10-m) wind circulation. In each quadrant,
10-m Vt is calculated at four equally-spaced azimuths (every 22.5 degrees).
There is more fuzzy logic here to again allow for asymmetries, but in
general, the overall picture of Vt is one where there must be a coherent
cyclonic circulation. In my discussions with Richard Pasch, he mentioned that
there is no firm, objective threshold that NHC uses for wind speed in making
the genesis determination for observed storms, but he suggested that greather
than 15 kts may be a good model threshold.

The fuzzy logic that I mentioned for this check does allow for an automatic
pass of this check for a quadrant if two of the four azimuths in that
quadrant have Vt values that exceed 17 kts, but then if that condition
doesn't exist, mean values of Vt are evaluated with allowable thresholds that
are less than 17 kts. Also, importantly, this check of Vt in each quadrant is
done separately at 75, 125 and 175 km radii, and if the check passes at any
one of those radii, then that entire quadrant passes this wind circulation
check. This is again to allow both for asymmetries and differences in stages
of development in the model TC.


**_Full scan:_**
- Candidate storms that were identified in the initial scan above are then put
through almost the same exact tracking procedure that is done for standard
"forward" tracking that is performed in operations for RSMC-identified
storms, in order to more accurately fix the center position. This is done by
using a mean of center fixes for mass and momentum parameters from the
near-surface layer up to 700 mb. One big difference from the forward tracking
is that there is an additional check done here with the genesis tracking
after a center is diagnosed by the tracker in order to make things a bit more
rigorous and more fully ensure that we are tracking an organized cyclone.
That check is for a closed MSLP contour, again using a contour interval that
is specified by the user in a namelist. This check is more rigorous than the
MSLP gradient check done above in the initial scan (and, BTW, the algorithm
is also vastly more complicated – this closed-contour checking algorithm is
far and away the most complicated subroutine I've ever written!). Some
leeway is permitted in this MSLP closed-contour checking procedure in order
to allow for the variability in intensity & organization often seen for
incipient model (and observed) TCs. Specifically, a rolling check is employed
whereby the closed-contour algorithm needs to pass only for at least half of
the lead times over the most recent 24h (i.e., for 6-hourly data, 3 of the
past 5 lead times must pass). The purpose of this leeway is to prevent the
occurrence of interrupted tracks, where the tracker could otherwise show a
broken model TC track that would count for two tracks, but in model-reality
it's just the same model TC that happened to weaken for 6 or 12 hours.

- **Tracker output for genesis-detection runs:** All of the typical tracker-related
output is provided in the modified ATCF file, plus some extras. Here’s a
rough list:
  - Time & location of cyclogenesis (not necessarily *TC* genesis... see next major bullet point for details)
  - Lat & Lon
  - Vmax
  - min MSLP
  - R34, R50, R64
  - RMW (point-based)
  - axisymmetric RMW
  - ROCI & the SLP at the ROCI
  - All three Cyclone Phase Space parameters
  - A flag that determines if a warm core exists in the 300-500 mb layer
  - 850-200 mb shear (performed using the same algorithm as in SHIPS,
    including their vortex removal scheme)
  - Area-averaged SST underneath the tracker-diagnosed center fix
  - Area-averaged and grid-point values of zeta850 aned zeta700
  - Area-averaged values of 850 mb divergence
  - Area-averaged values of 850 mb moisture divergence
  - Area-averaged values of RH in the 800-600 and 1000-925 mb layers
  - Area-averaged 500 mb omega

- It's important to note that while values are calculated for the CPS
parameters and for the simple, 300-500 mb layer warm core flag, none of those
parameters have any impact on whether or not tracking will continue to the
next lead time. Rather, their values are simply printed out with all of the
other diagnostics in the modified ATCF file, and then it's up to the user
after the tracking run is completed to determine which criteria to apply in
determining whether or not a system is tropical or non-tropical at a given
lead time. For this, I have a separate, follow-up script where I process all
of the tracks, and I stick pretty much identical to Bob Hart's criteria
listed in his papers & website. In this way, the user has access to the full
length of a cyclone's track data in the modified ATCF data and not just the
part that might be considered strictly tropical. It also allows the user to
apply different TC / non-TC thresholds to the same tracked data, rather than
having to run the tracker over again on the entire set of input data if you
want to change the criteria.

**One final note:** Some of the checks that are described above – in particular
the rigorous form of the MSLP gradient check, the low-level wind circulation
check, and the MSLP closed-contour check – are *not* used in the forward
tracking that is part of the operational tracker runs for RSMC-identified TCs.
This is intentional. The reason is that for an RSMC-identified storm, we
clearly know that a storm exists in nature, and it is important for the
forecasters to get model guidance on that storm. So I am very lenient in any
restrictions applied to the forward tracking, again with the goal of making
sure that the tracker is able to follow any of these RSMC-identified storms
to the end of the forecast period and provide that critical track & intensity
guidance. However, for genesis detection in the model, we need to be more
critical, i.e., Is this thing we’ve detected and started to track in the
model really a storm, or is it just noise? So whereas with the forward
tracking I err on the side of being much more lenient with tracking, with
genesis detection & tracking I am far more conservative in order to ensure
that a new, tracker-diagnosed model storm really is a model storm.