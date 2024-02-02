//return today date as yyyymmdd
String todaysDateYYYYMMDD(){
  //TODAY
  var dateTimeobject = DateTime.now();

  //Year in formet YYYY
  String year = dateTimeobject.year.toString();

  //month in the format mm
  String month = dateTimeobject.month.toString();
  if(month.length == 1){
    month = '0$month';
  }

  //day in the formate dd
  String day = dateTimeobject.day.toString();
  if(day.length == 1){
    day = '0$day';
  }

  //Final Formet
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
// convert string yyyymmdd to datetime object

DateTime createDateTimeobject(String yyyymmdd){
  int yyyy = int.parse(yyyymmdd.substring(0,4));
  int mm = int.parse(yyyymmdd.substring(0,4));
  int dd = int.parse(yyyymmdd.substring(0,4));

  DateTime dateTimeObject = DateTime(yyyy, mm , dd);
  return dateTimeObject;
}