require 'sendgrid-ruby'
include SendGrid

class ApplicationMailer < ActionMailer::Base
    def confirmation_instructions(user, token, argument)
        mail = SendGrid::Mail.new
        template_id = Rails.application.credentials.dig(:sendgrid_confirmation_email_id)
        mail.template_id = template_id
        mail.from = Email.new(email: "anamorais.dev@gmail.com")
        personalization = Personalization.new
        personalization.add_to(Email.new(email: user.email, name: "Ana Karolina"))
        personalization.add_dynamic_template_data(
            'link' => "http://localhost:4000/users/confirmation?confirmation_token=#{token}"
        )
        mail.add_personalization(personalization)
        puts mail.to_json

        sg = SendGrid::API.new(api_key: Rails.application.credentials.dig(:sendgrid_password))
        response = sg.client.mail._('send').post(request_body: mail.to_json)
        puts response.status_code
        puts response.body
        puts response.headers
    end
end
