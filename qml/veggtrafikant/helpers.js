function parseDate(dateInput) {
    var substrLength = dateInput.indexOf("+")-6
    var dateTime = new Date(parseInt(dateInput.substr(6,substrLength)))
    return dateTime
}
