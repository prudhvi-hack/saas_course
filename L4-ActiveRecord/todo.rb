require "active_record"

class Todo < ActiveRecord::Base
  def self.show_list
    puts "My Todo-list\n\n"
    puts "Overdue"
    puts list_Overdue.map { |todo| todo.to_displayable_string }
    puts "\n"
    puts "Due Today"
    puts list_due_today.map { |todo| todo.to_displayable_string }
    puts "\n"
    puts "Due Later"
    puts list_duelater.map { |todo| todo.to_displayable_string }
  end
  def self.add_task(new_task)
    new_task[:due_date] = Date.today + new_task[:due_in_days]

    new_todo = new_task.except (:due_in_days)
    new_todo[:completed] = false
    create!(new_todo)
  end
  def self.list_due_today
    where("due_date < ?", Date.today)
  end
  def self.list_Overdue
    where("due_date = ?", Date.today)
  end
  def self.list_duelater
    where("due_date > ?", Date.today)
  end

  def self.mark_as_complete!(id)
    todo = find(id)
    todo.completed = true
    todo.save
    todo
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_date == Date.today ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end
end
