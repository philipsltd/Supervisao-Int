
//const dashboard = document.getElementById("dashboard.html");///

function setTheContentOfTheSelectedMenuItem(idOfDivElement, whatWasSelected) {
    // all those embbeded quotes is because we need something like this:
    //  "<iframe src="https://www.w3schools.com" style="s1:v1; s2:v2; ..."></iframe>"
  
    var endpointString =
      '<IFRAME SRC="./' +
      whatWasSelected +
      '.html" style="width: 92vw; height:100vh; flex-grow: 1; border: none;  padding: 0;"></IFRAME>';
    console.log(endpointString);
    document.getElementById(idOfDivElement).innerHTML = endpointString;
    //document.getElementById(idOfDivElement).focus();
}

function dashboardClicked() {
    setTheContentOfTheSelectedMenuItem("contentOfHMI", "dashboard");
}

function executionClicked() {
    setTheContentOfTheSelectedMenuItem("contentOfHMI", "execution");
}

function monitoringCliked() {
    setTheContentOfTheSelectedMenuItem("contentOfHMI", "monitoring");
}
function failuresCliked() {
    setTheContentOfTheSelectedMenuItem("contentOfHMI", "failures");
}

function ajax_post_request(  endpoint,  query,  done_callback = null,  fail_callback = null) {
    const xhttp = new XMLHttpRequest();
    xhttp.onload = function () {
        if (done_callback !== null) {
        done_callback(this.responseText);
        }
    };
    xhttp.open("POST", endpoint);
    xhttp.send(query);
}

//Copiado dos slides
function setSwitchState(theSwitch, theOpositeSwitch) {
    var theSwitch1 = document.getElementById(theSwitch);
    var theSwitch2 = document.getElementById(theOpositeSwitch);
    if (theSwitch1.checked == true)
        theSwitch2.checked = false;
    return theSwitch1.checked;
}
/*
refreshFailuresStatistics();
    setInterval(function () {
      //refreshAlertsTable();
      refreshFailuresStatistics();
    }, 1000);

    function refreshFailuresStatistics() {
      ajax_post_request(
        "/rtx_get", "query=provide_failures_statistics_json",
        function (result) {
          console.log("query result = " + result.trim());
          //debugger;
          var jsObj = JSON.parse(result);
          document.getElementById( "totalFailures" ).innerHTML = jsObj.totalFailures;
          document.getElementById( "totalPending"  ).innerHTML = jsObj.totalPending;
        }
    );
}*/