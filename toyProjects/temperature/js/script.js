let string;
        let latitude;
        let longitude;

        let option= {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
        }

        // If I click on the button, the following code runs
        function getLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(success, error,option);
            } else {
                string = "Geolocation is not supported by this browser.";
                document.getElementById("today").innerHTML = string;
            }
        }

        // If getCurrentPosition is successful, the following code runs
        function success(position) {
            // Latitude and Longtitude
            latitude = position.coords.latitude;
            longitude = position.coords.longitude;

            // Internal Accuracy Checking Mechanism 
            // Currently limited by IP address
            // console.log("Latitude: " + latitude);
            // console.log("Longitude: " + longitude);
            // console.log("Accuracy: " + position.coords.accuracy);
            // document.getElementById("today").innerHTML = string;


            // Connecting to open-meteo API
            $.ajax({
                url: `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,relative_humidity_2m&hourly=temperature_2m,relative_humidity_2m,weather_code&models=kma_seamless&timezone=auto&forecast_days=5`,
                // data: {},
                type: "GET",
                dataType: "json",
                success: function(data) {
                    //console.log("Weather data");
                    console.log(data);
                    // Temperature and Humidity
                    let temperature = data.current.temperature_2m;
                    let humidity = data.current.relative_humidity_2m;

                    // Combined string for temperature and humidity
                    let result = "Current Temperature:" + temperature +
                                "  Humidity:" + humidity + "<br>";
                    result = result +  displayTemp(data)

                    // Printing combined string
                    
                    document.getElementById("today").innerHTML = result;
                }
            });
        }

        // if getCurrentPosition is not successful, the following code runs
        function error() {
            alert("Either the permission was not granted or location is unavailable.");
        }

        //now get humidity too. Rained and high humidity today (09/24) -> I need to get humidity also for my weather app practice.
        function displayTemp(data){
                        let d1Temp =[];
            let d1WC = [];
            let d1H = [];

            for(let i=0;i<24;i++){
                d1Temp[i]=data.hourly.temperature_2m[i];
                d1WC[i]=data.hourly.weather_code[i];
                d1H[i]=data.hourly.relative_humidity_2m[i];
            }
            let dayOneString = `Today's Temperature: ${Math.min(...d1Temp)} - ${Math.max(...d1Temp)} Humidity: ${Math.max(...d1H)}%\nExpectation: ${getWeather(Math.max(...d1WC))}\n`;

            let d2Temp = [];
            let d2WC = [];
            let d2H = [];
            for(let i=24;i<48;i++){
                d2Temp[i-24]=data.hourly.temperature_2m[i];
                d2WC[i-24]=data.hourly.weather_code[i];
                d2H[i-24]=data.hourly.relative_humidity_2m[i];
            }
            let dayTwoString = `Day 2's Temperature: ${Math.min(...d2Temp)} - ${Math.max(...d2Temp)} Humidity: ${Math.max(...d2H)}%\nExpectation: ${getWeather(Math.max(...d2WC))}\n`;

            let d3Temp = [];
            let d3WC = [];
            let d3H = [];
            for(let i=48;i<72;i++){
                d3Temp[i-48]=data.hourly.temperature_2m[i];
                d3WC[i-48]=data.hourly.weather_code[i];
                d3H[i-48]=data.hourly.relative_humidity_2m[i];
            }
            let dayThreeString = `Day 3's Temperature: ${Math.min(...d3Temp)} - ${Math.max(...d3Temp)} Humidity: ${Math.max(...d3H)}%\nExpectation: ${getWeather(Math.max(...d3WC))}\n`;

            let d4Temp = [];
            let d4WC = [];
            let d4H = [];
            for(let i=72;i<96;i++){
                d4Temp[i-72]=data.hourly.temperature_2m[i];
                d4WC[i-72]=data.hourly.weather_code[i];
                d4H[i-72]=data.hourly.relative_humidity_2m[i];
            }
            let dayFourString = `Day 4's Temperature: ${Math.min(...d4Temp)} - ${Math.max(...d4Temp)} Humidity: ${Math.max(...d4H)}%\nExpectation: ${getWeather(Math.max(...d4WC))}\n`;

            let d5Temp = [];
            let d5WC = [];
            let d5H = [];
            for(let i=96;i<120;i++){
                d5Temp[i-96]=data.hourly.temperature_2m[i];
                d5WC[i-96]=data.hourly.weather_code[i];
                d5H[i-96]=data.hourly.relative_humidity_2m[i];
            }
            let dayFiveString = `Day 5's Temperature: ${Math.min(...d5Temp)} - ${Math.max(...d5Temp)} Humidity: ${Math.max(...d5H)}%\nExpectation: ${getWeather(Math.max(...d5WC))}\n`;


            let totalWeather = ` ${dayOneString}<br>${dayTwoString}<br>${dayThreeString}<br>${dayFourString}<br>${dayFiveString}`;
            return totalWeather;
        }


        function getWeather(code){
            const n = Number(code);

            if (Number.isNaN(n)) return "Invalid code";

            // Exact matches
            if (n === 0) return "Clear weather";
            if (n === 45 || n === 48) return "Fog and hoarfrost deposit";
            if (n === 95) return "Thunderstorm (light to moderate, no hail)";
            if (n === 96) return "Thunderstorm (light to moderate, with hail)";

            // Grouped sets
            if (n === 1 || n === 2 || n === 3) {
                return n === 1 ? "Partly Cloudy" : n === 2 ? "Locally Cloudy" : "Overcast";
            }

            // Ranges with intensity buckets
            if (n >= 51 && n <= 55) {
                const intensity = n === 51 ? "Light" : n === 53 ? "Moderate" : n === 55 ? "Heavy" : "Light/Moderate/Heavy";
                return `${intensity} Drizzle`;
            }

            if (n >= 61 && n <= 65) {
                const intensity = n === 61 ? "Light" : n === 63 ? "Moderate" : n === 65 ? "Heavy" : "Light/Moderate/Heavy";
                return `${intensity} Rain`;
            }

            if (n >= 71 && n <= 75) {
                const intensity = n === 71 ? "Light" : n === 73 ? "Moderate" : n === 75 ? "Heavy" : "Light/Moderate/Heavy";
                return `${intensity} Snow`;
            }

            // Fallbacks for nearby standard WMO meanings (optional)
            if (n === 77) return "Snow Grains / Ice Pellets";
            if (n === 80 || n === 81 || n === 82) return "Rain Showers";
            if (n === 85 || n === 86) return "Snow Showers";

            // Default
            return "Unknown weather code";
            
            // Examples:
            // console.log(getWeatherDescription(0));   // "Clear weather"
            // console.log(getWeatherDescription(3));   // "Partly cloudy, locally cloudy, overcast"
            // console.log(getWeatherDescription(45));  // "Fog and hoarfrost deposit"
            // console.log(getWeatherDescription(53));  // "Drizzle (moderate)"
            // console.log(getWeatherDescription(61));  // "Rain (light)"
            // console.log(getWeatherDescription(75));  // "Snow (heavy)"
            // console.log(getWeatherDescription(95));  // "Thunderstorm (light to moderate, no hail)"
            // console.log(getWeatherDescription(96));  // "Thunderstorm (light to moderate, with hail)"
        }

        function goToScreen(n) {
            const screens = document.querySelectorAll('.screen');
            screens.forEach((s, i) => {
                s.classList.toggle('active', i === n - 1);
            });
        }

        function stopBgAnimation() {
            document.body.classList.remove('bg-running');
        }

        
