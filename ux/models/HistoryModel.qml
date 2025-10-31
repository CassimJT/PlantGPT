pragma Singleton
import QtQuick
import QtQuick.Controls
import QtCore

Item {
    id: historyModelManager

    property alias listmodel: listmodel
    // Persistent settings
    Settings {
        id: settings
    }

    // The actual model
    ListModel {
        id: listmodel

        ListElement { diseaseName: "Leaf Blight"; classIndex: 0; date: "2025-10-10" }
        ListElement { diseaseName: "Powdery Mildew"; classIndex: 1; date: "2025-10-11" }
        ListElement { diseaseName: "Root Rot"; classIndex: 2; date: "2025-10-12" }
        ListElement { diseaseName: "Yellow Rust"; classIndex: 3; date: "2025-10-13" }
        ListElement { diseaseName: "Bacterial Wilt"; classIndex: 4; date: "2025-10-14" }
        ListElement { diseaseName: "Late Blight"; classIndex: 5; date: "2025-10-15" }
        ListElement { diseaseName: "Downy Mildew"; classIndex: 6; date: "2025-10-16" }
        ListElement { diseaseName: "Crown Gall"; classIndex: 7; date: "2025-10-17" }
        ListElement { diseaseName: "Anthracnose"; classIndex: 8; date: "2025-10-18" }
        ListElement { diseaseName: "Leaf Curl Virus"; classIndex: 9; date: "2025-10-19" }
    }

    // --- Model management functions ---

    function addToHistory(diseaseName, classIndex, date) {
        if (!diseaseName || diseaseName.trim() === "" || classIndex < 0 || !date) {
            console.log("Invalid data: Cannot add empty field.")
            return
        }
        listmodel.append({ diseaseName: diseaseName, classIndex: classIndex, date: date })
        console.log("Data added to history:", diseaseName, classIndex, date)
    }

    function clearModel() {
        listmodel.clear()
    }

    function modelSize() {
        return listmodel.count
    }

    function deleteHistory(index) {
        if (index >= 0 && index < listmodel.count)
            listmodel.remove(index)
    }

    function persistHistory() {
        let data = []
        for (let i = 0; i < listmodel.count; i++) {
            let field = listmodel.get(i)
            if (field) data.push(field)
        }

        let jsonData = JSON.stringify(data)
        settings.setValue("historyModel", jsonData)
        console.log("History persisted.")
    }

    function loadHistory() {
        let savedData = settings.value("historyModel", "[]")
        let parsedData
        try {
            parsedData = JSON.parse(savedData)
        } catch (error) {
            console.log(`Error parsing data: ${error}`)
            return
        }

        if (Array.isArray(parsedData) && parsedData.length > 0) {
            clearModel()
            parsedData.forEach(item => listmodel.append(item))
            console.log("History loaded.")
        } else {
            console.log("No saved data found.")
        }
    }
}
