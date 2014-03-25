require 'active_record'
require './lib/employee'
require './lib/project'
require './lib/division'


database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)


def welcome
  puts "Welcome to the Employee Tracker App"
  menu
end

def menu
  choice = nil
  until choice == "e"
      puts "Press 'a' to add a new employee, 'l' to list all employees, 'd' to create a new division, 'dl' to list your divisions, 'e' to exit "
      puts "If you would like to assign a division to an employee, press 'p', Press 'f' to add a project,  Press 'w' to assign a project."
      choice = gets.chomp
      case choice
      when 'a'
       add
      when 'l'
       list
      when 'd'
        division
      when 'dl'
        div_list
        assign_division
      when 'p'
        assign_division
      when 'pl'
        proj_list
      when 'f'
        add_project
      when 'w'
        assign_project
      when 'e'
       puts "Good Bye!"
      else
      puts "Sorry, that wasn't a valid option."
      end
  end
end

 def add
  puts "Enter the name of the employee you want to add: "
  employee_name = gets.chomp
  employee = Employee.new({:name => employee_name})
  employee.save
  "'#{employee_name}' has been added to your Employee list"
  puts "What division would you like to add this employee too?"


end

def list
  puts " Here is the list of all employees"
  Employee.all.each { |employee| puts puts "#{employee.id}: #{employee.name}"}
end

def division
  puts "Enter the name of the division you woud like to create."
  new_division = gets.chomp
  division = Division.new({:name => new_division})
  division.save
  "'#{new_division}' has been added successfully."
end

def div_list
  puts " Here is a list of all of your divisions:"
  Division.all.each { |division| puts "#{division.id}: #{division.name}" }
end

def assign_division
  puts "Which employee do you want to add to a division?"
  list
  select_employee_id = gets.chomp
  employee = Employee.where({:id => select_employee_id}).first
  puts " Choose a division ID to assign"
  div_list
  division_id = gets.chomp
  employee.update_attributes({:division_id => division_id})
end

def add_project
  puts "Enter the name of the project you want to add: "
  project_name = gets.chomp
  project = Project.new({:name => project_name})
  project.save
  "'#{project_name}' has been added to your project list"
  puts "What division would you like to add this project too?"

end

def assign_project
  puts "Which project do you want to add to an employee?"
  proj_list
  select_project_id = gets.chomp
  project = Project.where({:id => select_project_id}).first
  puts " Choose a employee ID to assign"
  list
  employee_id = gets.chomp
  project.update_attributes({:employee_id => employee_id.to_i})
end

def proj_list
  puts " Here is a list of all of your projects:"
  Project.all.each { |project| puts "#{project.id}: #{project.name}" }
end

welcome



