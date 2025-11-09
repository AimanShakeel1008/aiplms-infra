import smtplib
from email.message import EmailMessage
msg = EmailMessage()
msg.set_content('Hello from infra test')
msg['Subject'] = 'Infra Test'
msg['From'] = 'no-reply@aip-lms.local'
msg['To'] = 'test@example.com'
with smtplib.SMTP('localhost', 1025) as s:
    s.send_message(msg)
print('sent')
