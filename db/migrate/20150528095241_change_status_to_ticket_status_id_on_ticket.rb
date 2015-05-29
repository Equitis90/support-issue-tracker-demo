class ChangeStatusToTicketStatusIdOnTicket < ActiveRecord::Migration
  def change
    rename_column :tickets, :status, :ticket_status_id
  end
end
