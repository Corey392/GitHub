package util;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
//import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/** Purpose:    Handles sending of email messages.
 *  @author     Unknown, Todd Wiggins, Mitchell Carr
 *  @version    1.01
 *	Created:    ?
 *	Modified:	05/05/2013
 *	Change Log: 05/05/2013: Added logger to exception. Disabled actual sending of message temporarily.
 *                  05/05/2013: Minor cleanup
 */
public class Email {

	//DO NOT CHANGE!!!
	private static final String username = "rpl.tafe.ourimbah@gmail.com";
	private static final String password = "studying2012";

	/**
         * Sends an email from the server to the target specified
         * @param toEmail Recipient's email address
         * @param subject Subject of the email
         * @param body Text to be sent in the email
         */
        public static void send(String toEmail, String subject, String body) {
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");

		Session session = Session.getInstance(props,
		  new javax.mail.Authenticator() {
                        @Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		  });

		try {
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(username));
			message.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(toEmail));
			message.setSubject(subject);
			message.setText(body);

			Logger.getLogger(Email.class.getName()).log(Level.INFO, "Email to send: {0}, subject: {1}, body: {2}", new Object[]{toEmail, subject, body});
			//TODO: Remove comments to get emails to send.
			//Transport.send(message);
		} catch (MessagingException e) {
			Logger.getLogger(Email.class.getName()).log(Level.SEVERE, null, e);
			throw new RuntimeException(e);
		}
	}
}