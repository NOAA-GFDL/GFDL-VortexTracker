Tim Marchok (timothy.marchok@noaa.gov)

NOAA / GFDL

12/8/2023

Some details on the wind radii & axisymmetric RMW diagnostic schemes in the
GFDL Vortex Tracker
----------------------------------------------------------------------------

This document provides an overview for how the upgraded schemes for diagnosing
wind radii and axisymmetric RMW (ARMW) work in the GFDL Vortex Tracker. The
wind radii scheme will be described first, then ARMW. For each, I'll first
give a very short, high-level overview on the motivation for the change and
how things work in the updated versions.

***Wind radii change motivation and high-level overview:*** The original version of
the tracker used a simple wind radii diagnosis scheme that targeted the wind
values of individual points and selected R34 based on a sorting of wind
values in each quadrant. An addition to the algorithm was made in 2013 to
provide an iterative capability for larger storms. This scheme worked fine
for coarse-resolution global models and even for higher resolution hurricane
models such as HWRF, HMON and the old GFDL hurricane model, because they all
had relatively smooth near-surface wind fields. However, testing with
high-resolution FV3-based models such as HAFS-A, HAFS-B and our GFDL
T-SHiELD model revealed problems with that scheme. Specifically, these
FV3-based models often generate convective flare-ups at larger radii with
accompanying wind bursts, and while realistic, it was clear that these
convective flare-ups and wind bursts were often too isolated and were
occurring too far from the storm to be considered part of the main
circulation of the storm. Yet such wind bursts were triggering the wind radii
scheme and assigning R34 values at these radii, leading to larger R34
forecast errors and biases. To address this, I created a new scheme that
analyzes the distribution of wind magnitude values in radial bands in each
quadrant, and I also created new algorithms that help to ensure that a
tracker-diagnosed R34 value can be considered part of the main circulation
of the TC.

***Details of the new wind radii algorithm:***

As described above, the main problem with using the old wind radii scheme on
hi-res, FV3-based models is that isolated, outlier wind areas were triggering
the scheme for R34 diagnosis. That type of scenario can be seen in Figure 1
for a T-SHiELD forecast of Hurricane Teddy from 2020.

ADD FIGURE 1
Figure 1. Precipitable water (shaded) and contours of wind magnitude for a
T-SHiELD forecast of Hurricane Teddy from 2020. Black contours delineate
areas with wind magnitude values greater than 34 kts. Yellow circles surround
small pockets of isolated, outlier winds greater than 34 kts (figure provided
by Kun Gao / GFDL).

I reached out to operational TC forecasters with this example from T-SHiELD
and others similar to it from the HAFS models and asked for their opinions.
Specifically, I asked, “If these outlier wind bursts were observed in
hurricanes in nature, would you assign R34 at such outer radii?” Their
response was that no, for these examples that I showed them, those winds
would not be considered part of the main circulation due to their isolated
nature and would not be included in their diagnosis of the observed R34.

In the new wind radii scheme, the distribution of wind magnitude in 3-km-wide
radial bins is considered (Figure 2). In each 3-km-wide radial bin in each
quadrant, the winds from the model’s output grid are interpolated to every
one degree of azimuth, giving 90 data points in each radial bin. The 95th
percentile wind speed value (**V**<sub>95th</sub>) in each radial bin is
designated as the representative value for that bin. A search for R34 begins
at a specified initial max radius (initially set to 370 km) and works inward
until **V**<sub>95th</sub> greater than or equal too 34 kts. If R34 is found
at a distance that is greater than 97% of the distance to the max radius,
then it is considered possible that the true R34 lies outside that initial
max radius.

ADD FIGURE 2
Figure 2. Schematic showing the framework for the updated R34 diagnosis
scheme in the GFDL Vortex Tracker. Lines that arc in the shown northeastern
quadrant represent the boundaries of 3-km-wide radial bins. The dots in the
one bin are representative of the 90 data points distributed equally at each
one degree of azimuth (all 90 are not shown).

If that is the case, then the whole search process iterates again, but out to
a distance of the previous max radius + 50 km. If needed, this can continue
out to a maximum possible radius of 1070 km, thus allowing for the diagnosis
of very large outlier storms, such as Sandy (2012). Once R34 has been
diagnosed by the tracker, an evaluation is performed to ensure that the winds
found in this R34-diagnosed radial bin may be considered as part of the main
circulation of the storm and not just an outlier. Several different checks
are used for this purpose. First, the mean Vt in this band in this quadrant
is calculated, and if it exceeds 17.5 m/s, then an automatic pass is given
and no further checks are performed. If that check does not pass, then a
“free-pass” percentile is checked inside that radial bin in that quadrant for
17.5 m/s exceedance. The percentile value for this “free-pass” check is
specified by the user, and I usually set it to the 67th percentile. So, in
other words, if at least 1⁄3 of the wind values in this radial band exceed
17.5 m/s, then this is another way to give an automatic pass for this R34 in
this quadrant without requiring further evaluation.

Those first two checks are in there to provide a simple pass for strong
circulations that are clearly part of a storm circulation. However, if
neither of those checks pass, then additional checks are performed that are
not as stringent as the first two but still test for a circulation. For these
next two checks, values that are calculated from the models winds are
compared against Holland wind profiles that are computed using the
tracker-derived Vmax and ARMW values. For the first check, we compute the
4-quadrant mean Vt at the R34 distance (**Vt**<sub>R34</sub>), and we require that **Vt**<sub>R34</sub>
must be greater than or equal to (0.5 * Holland_Vt) at that radius, where the
Holland_Vt is computed using a weak value of B=2.0. The reasons I use a weak
value of B and that I only require the VtR34 to be greater than _half_ the
Holland value are that: (1) we are not trying to be overly stringent... we
are just using a comparison to a Holland profile with tracker-diagnosed
input as a sort of “guard rail” for the wind radii scheme in trying to
evaluate whether there is a mean circulation associated with the winds in
this R34 band, and (2) the Holland profile is an analytical profile meant for
mean conditions that may or may not match closely with the variable structure
of different model TCs.

If the first Holland profile check just described fails, then an additional
Holland profile check is done. This one, however, is performed using the
**Vt**<sub>R34</sub> computed using only points from the radial bin within this quadrant,
not from the 4-quadrant mean. The purpose of doing this is to allow for the
possibility that we have a highly asymmetric storm and we don’t want to fail
the R34 point prematurely based on the azimuthally averaged results. But here
we are slightly more stringent and we require that **Vt**<sub>R34</sub> in this quadrant
must be greater than or equal too (0.6 * Holland_Vt) at this radius.

If any of these checks pass at the tracker-diagnosed R34, then we perform
one final set of checks. The idea here is that if we have found an R34 radius
value, we want to ensure that there is some substantial amount of width to
this wind value, again, to discount the possibility that it is associated
with a small, isolated band of winds. So here, we perform these same Holland
checks for each successive radial bin inward of the tracker-diagnosed R34 to
a distance that is specified by the user. I set this at 15 km, which I think
is reasonable. I initially had it set at 30 km, but I found that I was
missing some reasonably substantial areas of winds and associated R34
diagnosis with it set to 30. A value of 15 km is reasonable and could be
considered representative of the width of some strong rainbands that could
have winds exceeding 34 kts and be considered part of the main circulation of
the TC.

If these checks fail, then the algorithm abandons that candidate R34 and
moves inward by one 3-km-wide radial bin to perform all of this evaluation
again on the next radially inward bin. Once R34 is finally diagnosed and
passes all these checks, then the algorithm moves inward looking for R50
and R64. The diagnosis of R50 and R64 utilizes the same method with checking
the representative wind for each radial bin, using the 95th percentile wind
value. However, none of the checks are performed for R50 and R64 that are
done for R34. The reason for not doing the checks is that the check for R34
acts as sort of a “gatekeeper” for ensuring that once we get to the
tracker-diagnosed R34 and have passed all of the checks, we are into what can
truly be considered a circulation that is part of the TC and will include
stronger winds within that R34 limiting radius.

***Details of the diagnosis of axisymmetric RMW:***

In the current version of the tracker used in HAFS-A, HAFS-B and the GFDL
SHiELD and T-SHiELD models, two values for RMW are reported. The first value
is a point-based RMW (pRMW). Here, the distance from the tracker-diagnosed
storm fix to the Vmax grid point location is computed, and this value is
reported in the standard location in the ATCF record. The second value is an
azimuthally averaged value, called axisymmetric RMW (ARMW). This value is
reported in a non-standard addendum section at the end of the ATCF record,
and it can been seen in the ATCF records identified by “ARMW” followed
by two values – the value of ARMW distance in n mi and also the azimuthally
averaged value of V (not Vt) at the ARMW distance.

To compute ARMW, a similar method is used as for the wind radii above, where
the model winds are interpolated to points in 3-km-wide bands. But here, the
calculations are performed over the entire circumference of the storm as
opposed to just one quadrant. Also, the calculations are performed at 24
equally-spaced intervals (every 15 degrees) surrounding the storm. To account
for the possibility that there may be vastly different inner core structures
for model storms with intensities ranging from very weak to very intense, an
allowance is made for up to four overlapping passes of the ARMW search
algorithm, with the overlapping ranges as follows: 0-125 km, 75-200 km,
150-275 km, and 225-350 km.

Once the maximum ARMW is located, a check is done to ensure that the wind
profile increases while approaching this ARMW from the center, and then
decreases going from this ARMW to distances further out, agreeing with
typical TC wind profiles. In order to test this, the following conditions
must be met:

$\∫δ𝑉/δ𝑟 > 0 𝑓𝑜𝑟𝑟 < 𝐴𝑅𝑀𝑊$
$\∫δ𝑉/δ𝑟 < 0 𝑓𝑜𝑟 𝑟 > 𝐴𝑅𝑀𝑊$

If this condition cannot be met in the current search range of distances,
then a new search is conducted in the next overlapping distance range.