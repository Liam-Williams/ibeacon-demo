# iBeacon-demo
iBeacon demo project for Lighthouse Labs Lecture

## Remember
- Set NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription in your info.plist
- You need to have always or when in use location authorized to monitor and range beacons
- You need to request always location to monitor beacon regions in the background (& you can't range beacons in the background)
- Beacon proximity is approximate
  - Immediate = a few inches
  - Near = a few meters
  - Far = more than a few meters
  - Unkown = weak signal or none)
