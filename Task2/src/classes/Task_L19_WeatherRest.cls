public class Task_L19_WeatherRest {

    public class DailyWeather {
        @AuraEnabled
        public String dayDate {
            get;
            set;
        }

        @AuraEnabled

        public List<Weather> temperatures {
            get;
            set;
        }

        @AuraEnabled
        public String imgSrc {
            get;
            set;
        }

    }

    public class Weather {
        @AuraEnabled
        public Decimal temperature {
            get;
            set;
        }

        @AuraEnabled
        public String description {
            get;
            set;
        }

        @AuraEnabled
        public String now {
            get;
            set;
        }

        @AuraEnabled
        public String imgSrc {
            get;
            set;
        }

    }

    @AuraEnabled

    public static List<Task_L19_WeatherRest.DailyWeather> getDailyWeather() {
        List<DailyWeather> resultWeathers = new List<DailyWeather>();
        DailyWeather dailyWeather;// = new DailyWeather();
        String response = getOpenWeatherMapResponse();
        if (response != null) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response);
            List<Object> days = (List<Object>) results.get('list');
            for (Object dayObject : days) {
                Map<String, Object> day = (Map<String, Object>) dayObject;
                Weather w = new Weather();
                String temp = '' + day.get('dt_txt');
                Datetime d = Datetime.valueOf(temp);
                d = d.addHours(3);
                w.now = d.format('HH:mm');//temp.substring(11,16);
                Map<String, Object> main = (Map<String, Object>) day.get('main');
                Decimal temperature = (Decimal) main.get('temp');
                temperature = temperature.setScale(1);
                w.temperature = temperature;
                temp += ' - ' + temperature + '\u00b0C';
                List<Object> weather = (List<Object>) day.get('weather');
                Map<String, Object> weather0 = (Map<String, Object>) weather[0];
                temp += ' (' + weather0.get('main') + ')';
                w.description = '' + weather0.get('description');
                w.imgSrc = 'https://openweathermap.org/img/w/' + weather0.get('icon') + '.png';
                System.debug(w);
                if (d.hour() == 0) {
                    dailyWeather.imgSrc = dailyWeather.temperatures.get(dailyWeather.temperatures.size() / 2).imgSrc;
                    resultWeathers.add(dailyWeather);
                    dailyWeather = null;
                }
                if (dailyWeather == null) {
                    dailyWeather = new DailyWeather();
                    dailyWeather.dayDate = d.format('dd.MM.YYYY');
                    dailyWeather.temperatures = new List<Task_L19_WeatherRest.Weather>();
                }
                dailyWeather.temperatures.add(w);
            }
            resultWeathers.add(dailyWeather);

        }
        return resultWeathers;
    }

    public static String getOpenWeatherMapResponse() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://api.openweathermap.org/data/2.5/forecast'
                + '?id=620127&APPID=bc67534c54ad35c33b9f25374ab7466c&units=metric');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

//System.debug(response.getBody());
//System.debug(response.getStatusCode());

        if (response.getStatusCode() == 200) {
            return response.getBody();
        }
        return null;
    }

    public class WeatherClass {
        public String date_txt;
        public Decimal temp;
        public String weather_txt;
    }

    public static List<WeatherClass> getWeather() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://api.openweathermap.org/data/2.5/forecast'
                + '?id=620127&APPID=bc67534c54ad35c33b9f25374ab7466c&units=metric');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
// If the request is successful, parse the JSON response.
        System.debug(response.getBody());
        System.debug(response.getStatusCode());
        List<String> resultStrings = new List<String>();
        List<WeatherClass> resultWeathers = new List<WeatherClass>();
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> days = (List<Object>) results.get('list');
            for (Object dayObject : days) {
                Map<String, Object> day = (Map<String, Object>) dayObject;
                WeatherClass w = new WeatherClass();
                String temp = '' + day.get('dt_txt');
                w.date_txt = temp;
                Map<String, Object> main = (Map<String, Object>) day.get('main');
                Decimal temperature = (Decimal) main.get('temp');
                temperature = temperature.setScale(1);
                w.temp = temperature;
                temp += ' - ' + temperature + '\u00b0C';
                List<Object> weather = (List<Object>) day.get('weather');
                Map<String, Object> weather0 = (Map<String, Object>) weather[0];
                temp += ' (' + weather0.get('main') + ')';
                w.weather_txt = '' + weather0.get('main');
                resultStrings.add(temp);
                resultWeathers.add(w);
                System.debug(temp);
            }
        }
        return resultWeathers;
    }
    public static String getStr() {
        return 'Oloo!';
    }

}