<?php
$email = $_REQUEST['email'] ;
$message = $_REQUEST['message'] ;

mail( "harnold@rockarch.org", "Feedback Form Results",
$message, "From: $email" );

// If this is an AJAX call, echo out a JSON object for Javascript
if ($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest') {
$json = array(
'success' => $success,
'message' => $message,
'server' => $_SERVER
);

echo json_encode($json);

// Else, just display the message on a new page
} else {
echo 'Page was submitted…';
echo $message;
}

?>