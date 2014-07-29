/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 */

import QtQuick 2.0
import "jsonpath.js" as JSONHelper

Item {
    property string source: ""
    property string json: ""
    property string query: ""

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count

    property string _lastQueryTime: Date.now()

    onSourceChanged: {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        _lastQueryTime = Date.now()
        xhr.queryTime = _lastQueryTime
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.queryTime === _lastQueryTime) {
                json = xhr.responseText;
            }
        }
        xhr.send();
    }

    onJsonChanged: JSONHelper.updateJSONModel(jsonModel, json, query)
    onQueryChanged: JSONHelper.updateJSONModel(jsonModel, json, query)
}
