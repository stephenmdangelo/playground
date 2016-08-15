import QtQuick 2.0 as QQ

QQ.Text {
    id: text_delegate
    text: "Item #" + (index + 1)
    color: QQ.ListView.isCurrentItem ? "red" : "blue"
    font.bold: text_delegate.QQ.ListView.isCurrentItem
    anchors.horizontalCenter: parent.horizontalCenter
}
