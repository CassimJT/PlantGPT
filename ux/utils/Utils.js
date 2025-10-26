//getting current time
function getCurrentTime() {
    var currentData = new Date();
    var hours = currentData.getHours();
    var minites = currentData.getMinutes();
    var ampm = hours >=12 ?"PM" : "AM"

    var formrmatedHour = hours < 10 ? "0" + hours : hours
    var formatedMinites = minites < 10 ? "0" + minites : minites

    return formrmatedHour + ":" + formatedMinites +" "+ ampm
}
