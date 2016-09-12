<?php
    
    include_once("config.inc.php");

    // Only process POST requests.
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        echo "Sending CAPTCHA";
        // reCAPTCHA
        $secret = $config["reCAPTCHA"];
        $response = ($_POST["g-captcha-response"]);
        $url = 'https://www.google.com/recaptcha/api/siteverify';
        $data = array('secret' => $secret, 'response' => = $response);
        
        //use key 'http' even if you send the request to https://...
        $options = array(
            'http' => array(
               'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
               'method'  => 'POST',
                'content' => http_build_query($data)
            )
        );
        $context  = stream_context_create($options);
        echo $context
        $result = file_get_contents($url, false, $context);
        echo $result
        if ($result === FALSE) { 
            exit(1); 
        }
                
        
        // Get the form fields and remove whitespace.
        $subject = trim($_POST["subject"]);
        $email = filter_var(trim($_POST["email"]), FILTER_SANITIZE_EMAIL);
        $message .= '<html><body>';
        $message .= trim($_POST["message"]);
        $message .= '</body></html>';

        // Check that data was sent to the mailer.
        if ( empty($subject) OR empty($message) OR !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            // Set a 400 (bad request) response code and exit.
            //http_response_code(400);
            echo "Oops! There was a problem with your submission. Please complete the form and try again.";
            exit;
        }

        // Build the email headers.
        $email_headers .= "From: Rockefeller Archive Center <archive@rockarch.org>\r\n";
        $headers .= "Reply-To: Rockefeller Archive Center <archive@rockarch.org>\r\n";
        $email_headers .= "MIME-Version: 1.0\r\n";
        $email_headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";

        // Send the email.
        if (mail($email, $subject, $message, $email_headers)) {
            // Set a 200 (okay) response code.
            //http_response_code(200);
            echo "Thank You! Your message has been sent.";
        } else {
            // Set a 500 (internal server error) response code.
            //http_response_code(500);
            echo "Oops! Something went wrong and we couldn't send your message.";
        }
        
        var_dump($result);

    } else {
        // Not a POST request, set a 403 (forbidden) response code.
        //http_response_code(403);
        echo "There was a problem with your submission, please try again.";
    }

?>