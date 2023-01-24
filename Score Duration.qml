import QtQuick 2.0
import MuseScore 3.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.3
import QtQuick.Window 2.3
import Qt.labs.settings 1.0

//Changelog:
//1.1.3: MuseScore 4 Compatibility
//1.1.2: Fixed a bug which meant settings only saved on 60s =< scores < 3600s
//       Fixed a bug where a score of eg. 61 seconds could be saved as 1:1 (preferred: 1:01)
//       Text in the pop-up window doesn't automatically add plurals to all units.
//       Text in the pop-up window won't display empty quotes if no score title was found.
//       Various code simplifications
//1.1.1: The plugin now saves selected options to settings.
//1.1.0: The plugin can now write the duration to Score Properties, in a variety of formats.
//1.0.1: Initial functional release

MuseScore {
      menuPath: "Plugins.Score Duration"
      description: qsTr("Outputs a score's duration in hours, minutes, and seconds.")
      version: "1.1.2"
      requiresScore: true
      
       Component.onCompleted : {
        if (mscoreMajorVersion >= 4) {
           title = qsTr("Score Duration") ;
           thumbnailName = "logo.png";
           categoryCode = "analysis";
           } //if
       }


      Text {
      id: savetext //value that gets written to tag
      }
      
      //different time formats
      Text {
      id: savetext1 //yes units no seconds
	}
      
      Text {
      id: savetext2 //no units no seconds (YouTube thumbnail format)
      }
      
      Text {
      id: savetext3 // yes units yes seconds
      }
      
      Text {
      id: savetext4 // no units yes seconds
      }
      
onRun: {
      var score = curScore;
      var dur = score.duration;
      
      //activate advanced menu if it was left on last run
      if (saveprop.checked == true) {
            seconds.visible = true;
            units.visible = true;
            tagnamelabel.visible = true;
            tagname.visible = true;
            } //if
      
      //time calculation
      var dursec = dur % 60;      
      var durmin = (dur - dursec) / 60;
      var durmin2 =  durmin % 60;
      var durh = (durmin-durmin2) / 60;
      
      //text format for window
      var titleformat = ("Your score '" + score.title + "' is ");
      var hourtext = ""
      var hourtype = ""
      var hourpunct = ""
      var mintext = ""
      var mintype = ""
      var minpunct = ""
      var sectext = ""
      var sectype = ""
      var abssec = (" long (" + dur + " seconds).");
      var puncttype = 0;
      
      if (score.title == "") {
            titleformat = "Your score is ";
            }   
            
      if (durh != 0) {
            puncttype = puncttype + 1;
            hourtext = durh;
            if (durh == 1) {
                  hourtype = " hour";
                  } else {
                  hourtype = " hours";         
                  }
            }
                  
      if (durmin2 != 0) {
      //we want to display durmin2 rather than durmin; durmin can go over 60 but otherwise the two vars are the same.
            puncttype = puncttype + 2;                  
            mintext = durmin2;
            if (durmin2 == 1) {
                  mintype = " minute";
                  } else {
                  mintype = " minutes";
                  }
            }           
      
      if (dursec != 0) {
            puncttype = puncttype + 4;
            sectext = dursec;
            if (dursec == 1) {
                  sectype = " second"
                  } else {
                  sectype = " seconds"
                  }
            }      
      
      if (puncttype == 3) {
            hourpunct = " and "
            }
       
      if (puncttype == 5) {
            hourpunct = " and "
            }
           
      if (puncttype == 6) {
            minpunct = " and "
            }
       
      if (puncttype == 7) {
            hourpunct = ", "
            minpunct = ", and "
            }
                  
      if (durmin == 0) {
            abssec = " long."
            }
      
      if (dur == 0) {
            sectext = dur;
            sectype = " seconds"
            }
                  
      ddtext.text = (titleformat + hourtext + hourtype + hourpunct + mintext + mintype + minpunct + sectext + sectype + abssec);
      console.log(ddtext.text);                                                                      
      
      //save format for scores >= 3600s
      if (durmin >= 60) {
            //sends results to user window and activates it            
            savetext1.text = (durh + " h, " + durmin2 + " min, " + dursec + " s");
            if (durmin2 >= 10) {
                  if (dursec >= 10) {
                        savetext2.text = (durh + ":" + durmin2 + ":" + dursec);
                        } else {
                        savetext2.text = (durh + ":" + durmin2 + ":0" + dursec);
                        } //innerelse
             } else {
                   if (dursec >= 10) {
                        savetext2.text = (durh + ":0" + durmin2 + ":" + dursec);
                        } else {
                        savetext2.text = (durh + ":0" + durmin2 + ":0" + dursec);
                        } //innerelse
             } //outerelse                             
            savetext3.text = (dur + " s");
            savetext4.text = dur;
            durationDialog.visible = true;
            return;
            }

      //save format for scores > 60s 
      if (durmin == 0) {            
            savetext1.text = (dursec + " s");
            //to avoid an 8 second score to result in 0:8 (preferred: 0:08)
            if (dursec >= 10) {                  
                  savetext2.text = ("0:" + dursec);
                  } else {
                  savetext2.text = ("0:0" + dursec);
                  }
            savetext3.text = (dur + " s");
            savetext4.text = dur;
            durationDialog.visible = true;
            return;
            }

      //save format for 60s =< scores < 3600s      
      savetext1.text = (durmin + " min, " + dursec + " s");
      if (dursec >= 10) {             
                  savetext2.text = (durmin + ":" + dursec);
            } else {
            savetext2.text = (durmin + ":0" + dursec);
            }
      savetext3.text = (dur + " s");
      savetext4.text = dur;
      durationDialog.visible = true;

} //onRun

function saveToTag() {
//executed on button click or return key from text field
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
                              
            var actTagName = "duration"
            //checks for alternate tag name
            if (tagname.text != "") {
                  actTagName = tagname.text                      
                  }                       
            console.log("Writing '" + savetext.text  + "' to tag '" + actTagName + "'.");
            curScore.setMetaTag(actTagName, savetext.text);   
                                 
      } else {
      //wanted if we dont save to score properties
      console.log("Not saving to Score Properties.")
      }
} //function      
      
Dialog {
//window shown to end user
	id: durationDialog
	visible: false; //is changed once calculation has finished
	title: qsTr("Score Duration");

	standardButtons: StandardButton.Ok
	     onAccepted: {
                  saveToTag()
                  console.log("Closing...")            
                  durationDialog.close();
	           } //onAccepted

       /*Button {
            id: ok
            text: OK
            x: parent.width - 10
            y: - 100
            }*/ //Alternate button program for potential switch to ApplicationWindow

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
                              if (checked) {
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
                  spacing: 20;
                  
                  CheckBox {
                        id: units;
                        visible: false;
                        checked: true;
                        text: "Save Units"
                        //if (! checked) {}
                        } //CheckBox
                        
                  CheckBox {
                        id: seconds;
                        visible: false;
                        checked: false;
                        text: "Seconds only"	     
                        //if (! checked) {}
                        } //CheckBox
                        
                  } //RowLayout
                  
            RowLayout {
                        
                  Label {
                        id: tagnamelabel;
                        visible: false;
                        text: "TagName: "
                        //Layout.alignment: Qt.AlignRight
                        //anchors.right: units.right neither of these do anything
                        } //Label

                  TextField {
                        id: tagname
                        visible: false
                        placeholderText: "duration"
                        
                        Keys.onReturnPressed: {
                              saveToTag()
                              console.log("Closing...")
                              durationDialog.close();                                                            
                              } //onReturnPressed
                              
                        } //Textfield 
                        
                  } //RowLayout
                  
            }//ColumnLayout
            
	} //Dialog

Settings {
      id: settings
      category: "ScoreDurationPlugin"
      property alias saveprop:    saveprop.checked
      property alias units:       units.checked
      property alias seconds:     seconds.checked
      property alias tagname:     tagname.text
      } //settings

} //Musescore
