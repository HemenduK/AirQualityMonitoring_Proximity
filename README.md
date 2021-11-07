# AirQualityMonitoring_ProximityLabs
# Air Qulity Monitoring App

- Live city wise Air Quality Index
- AQI highlighted by different color based on level 
- AQI index guide
- AQI live tracking with line chart 

# Architecture
Used MVVM Architecture to develope tihs App.

- **LiveAQIVC** ViewController used to display Live city wise Air Quality Index.
- **AirQualityViewModel** used to fetch data from socket URL (ws://city-ws.herokuapp.com/) and ViewModel will transfer AQI data to ViewController through closure.
- **AirQualityModel** used to initialise properties get from socket response. Also declared Air Quality Range in that.
- **GraphAQVC** used to display line chart of Air Quality Index.
- **AQIGuideVC** used to giude of Air Quality Index Range.

# Pods

- Starscream : Used for socket connection
- Charts : Used for display live data in Line Chart

![Simulator Screen Shot - iPhone 13 - 2021-11-07 at 13 33 22](https://user-images.githubusercontent.com/42895345/140639816-049a9369-30ab-4c3f-9e81-d5493f273ad9.png)

![Simulator Screen Shot - iPhone 13 - 2021-11-07 at 13 33 20](https://user-images.githubusercontent.com/42895345/140639817-dace4cf8-4703-48b4-96e7-03aa3f007128.png)

![Simulator Screen Shot - iPhone 13 - 2021-11-07 at 13 33 12](https://user-images.githubusercontent.com/42895345/140639820-7e2ee2e3-1064-4ff1-9577-283065f88935.png)
