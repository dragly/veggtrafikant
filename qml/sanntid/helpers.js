function parseDate(dateInput) {
    var substrLength = dateInput.indexOf("+")-6
    var dateTime = new Date(Date.parse(dateInput))
    return dateTime
}
