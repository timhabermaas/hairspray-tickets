# encoding: utf-8

class OrderMailer < ActionMailer::Base
  default from: "ticketing@hgr-musical.de"

  def ordered_email(order)
    @order = order
    mail to: @order.email, subject: "Ihre Ticket-Bestellung für „HAIRSPRAY – The Musical“"
  end

  def payment_confirmation_email(order)
    @order = order
    mail to: @order.email, subject: "Bestätigung Zahlungseingang für Ihre Tickets zu „HAIRSPRAY – The Musical“"
  end
end
