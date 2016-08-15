import QtQuick 2.0

ListView {
    width: 500
    height: 500
    model: 5
    focus: true
    delegate: Delegate {
        id: delegate
        scale: delegate.ListView.isCurrentItem ? 1.2 : 1
        font.italic: ListView.isCurrentItem
    }
}
