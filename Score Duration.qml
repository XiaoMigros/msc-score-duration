import QtQuick 2.0
import MuseScore 3.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.3

MuseScore {
      menuPath: "Plugins.Score Duration"
      description: qsTr("Outputs a score's duration in hours, minutes, and seconds.")
      version: "1.1.0"
      requiresScore: true

      Text {
      id: savetext //value that gets written to tag
      }
      
      Text {
      id: savetext1 //yes units no seconds
	}
      
      Text {
      id: savetext2 //no units no seconds (YouTube thumbnail format)
      }
      
      Text {
      id: savetext3 // yes units yes seconds (dur + s)
      }
      
      Text {
      id: savetext4 // no units yes seconds (dur)
      }
      
      onRun: {
      var score = curScore;
      var dur = score.duration;
      //console.log("all set!")
      
      //time calculation for scores < 3600s
      var dursec = dur % 60
      var durmin = (dur - dursec)/60
      
      //time calculation for scores >= 3600s
      if (durmin >= 60) {
            var durmin2 =  durmin % 60
            var durh = (durmin-durmin2)/60
            //sends results to user window and activates it
            console.log ("Calculated score duration: " + durh + " h, " + durmin2 + " min, " + dursec + " s. (" + dur + " s).")
            ddtext.text = ("Your score '" + score.title + "' is " + durh + " hours, " + durmin2 + " minutes, and " + dursec + " seconds long (" + dur + " seconds).")
            savetext1.text = (durh + " h, " + durmin2 + " min, " + dursec + " s")
            savetext2.text = (durh + ":" + durmin2 + ":" + dursec)
            savetext3.text = (dur + " s")
            savetext4.text = dur
            durationDialog.visible = true;
            return;
            }

      //formatting for scores > 60s 
      if (durmin == 0) {
            console.log ("Calculated score duration: " + dursec + "s")    
            ddtext.text = ("Your score '" + score.title + "' is " + dursec + " seconds long.")
            savetext1.text = (dursec + " s")
            savetext2.text = ("0:" + dursec)
            savetext3.text = (dursec + " s")
            savetext4.text = (dursec)
            durationDialog.visible = true;
            return;
            }

      //formatting for 60s =< scores < 3600s
      console.log ("Calculated score duration: " + durmin + " min, " + dursec + " s. (" + dur + " s).")
      ddtext.text = ("Your score '" + score.title + "' is " + durmin + " minutes and " + dursec + " seconds long (" + dur + " seconds).")
      savetext1.text = (durmin + " min, " + dursec + " s")
      savetext2.text = (durmin + ":" + dursec)
      savetext3.text = (dur + " s")
      savetext4.text = dur
      durationDialog.visible = true;

      } //onRun

Dialog {
//window shown to end user
	id: durationDialog
	visible: false; //is changed once calculation has finished
	title: qsTr("Score Duration");

	standardButtons: StandardButton.Ok
	     onAccepted: {
            if (saveprop.checked == true) {
            //checks for save to score properties
            
                  //tag content formatting
                  if (units.checked == true && seconds.checked == false) {
                        savetext.text = savetext1.text
                        }
                  if (units.checked == false && seconds.checked == false) {
                        savetext.text = savetext2.text
                        }
                  if (units.checked == true && seconds.checked == true) {
                        savetext.text = savetext3.text
                        }
                  if (units.checked == false && seconds.checked == true) {
                        savetext.text = savetext4.text
                        }      
            
                  //checks for alternate tag name
                  if (tagname.text != "") {
                        console.log("Writing '" + savetext.text + "' to tag '" + tagname.text + "'.");
                        curScore.setMetaTag(tagname.text, savetext.text);
                        durationDialog.close();
                        } else {
                  console.log("Writing '" + savetext.text  + "' to tag 'duration'.");
                  curScore.setMetaTag("duration", savetext.text);
                  durationDialog.close();
                  } //else
               } //saveprop
	     durationDialog.close();
	     } //onAccepted

       /*Button {
            id: ok
            text: OK
            x: parent.width - 10
            y: - 100
            }*/ //Alternate button program for switch to ApplicationWindow

	Text {
		id: ddtext
	} //Text


      ColumnLayout {
            id: mainLayout
            anchors.margins: 10
            anchors.top: ddtext.bottom
            anchors.topMargin: 10
            //columns: 3 -remnant from gridlayout
            
            RowLayout {
                  
                  CheckBox {
                  id: saveprop
                  text: "Save to Score Properties"
                  onClicked: {
                  if (checked == true) {
                        seconds.visible = true
      	           units.visible = true
                        tagnamelabel.visible = true
                        tagname.visible = true
            		} else {
                        units.visible = false
                        seconds.visible = false
                        tagnamelabel.visible = false
                        tagname. visible = false
                        }

                     } //on clicked
                  } //CheckBox
                  
               } //RowLayout
               
            RowLayout {               
                  spacing: 20
                  
                  CheckBox {
                        id: units
	                 visible: false;
                        checked: true;
                        text: "Save Units"
                        //if (! checked) {}
                        } //CheckBox
                        
                  CheckBox {
                        id: seconds
                        //anchors.left: units.right + 20;
	                 visible: false;
                        checked: false;
                        text: "Seconds only"	     
                        //if (! checked) {}
                        } //CheckBox
                        
                  } //RowLayout
                  
            RowLayout {
                        
                  Label {
                        id: tagnamelabel
                        visible: false
                        text: "TagName: "
                        Layout.alignment: Qt.AlignRight
                        } //Label

                  TextField {
                        id: tagname
                        visible: false
                        placeholderText: "duration"
                        Keys.onReturnPressed: {
                              //copied from the button, theres probably an easier way to do this by using a non standardButton
                              
                              if (saveprop.checked == true) {
                              //checks for save to score properties
            
                              //tag content formatting
                              if (units.checked == true && seconds.checked == false) {
                                    savetext.text = savetext1.text
                                    }
                              if (units.checked == false && seconds.checked == false) {
                                    savetext.text = savetext2.text
                                    }
                              if (units.checked == true && seconds.checked == true) {
                                    savetext.text = savetext3.text
                                    }
                              if (units.checked == false && seconds.checked == true) {
                              savetext.text = savetext4.text
                                    }      
            
                              //checks for alternate tag name
                              if (tagname.text != "") {
                                    console.log("Writing '" + savetext.text + "' to tag '" + tagname.text + "'.");
                                    curScore.setMetaTag(tagname.text, savetext.text);
                                    durationDialog.close();
                                    } else {
                              console.log("Writing '" + savetext.text + "' to tag 'duration'.");
                              curScore.setMetaTag("duration", savetext.text);
                              durationDialog.close();
                              } //else
                        } //saveprop
                              
                              } //onReturnPressed
                              
                        } //Textfield 
                        
                  } //RowLayout
                  
            }//ColumnLayout
            
	} //Dialog

} //Musescore
