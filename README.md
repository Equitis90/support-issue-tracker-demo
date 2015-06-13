# README #

## Support issue tracker demo app ##

* Customers do not need to login to create a issue ticket. To create a ticket they need to specify their name, email, department and discribe issue.
* Each new ticket is assigned a unique reference in the format similar to ABC-123456. - When a new ticket is added, the customer receives an email confirming their request has been received along with their unique reference. 

Staff interface
* Each member of staff have a username and password to login to the system. Staff can view a list of all tickets from their department. Staff able to reply to the ticket by simply entering their response into a text field and setting new status for the ticket. All changes to the status tracked with each staff reply. All changes e-mailed to the client.
* Each ticket can be assigned a status - ʻWaiting for Staff Responseʼ, ʻWaiting for Customerʼ, ʻOn Holdʼ, ʻCancelledʼ or ʻCompletedʼ - further status may wish to be added in the future.
* When a ticket is first created or updated by the customer, it assigned the ʻWaiting for Staff Responseʼ status.
* Staff able to quickly open up a new ticket by entering itʼs reference number into a search field.

## Setting up app #

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Project can be opened in RubyMine IDE. 
Install ruby (2.1.1 [here](http://rubyinstaller.org/downloads/ "http://rubyinstaller.org/downloads/"), and DevKit from the same page [installation notes](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit "https://github.com/oneclick/rubyinstaller/wiki/Development-Kit")), and Postgresql (can be downloaded from [here](http://www.postgresql.org/download/ "http://www.postgresql.org/download/")).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;First of all you need to setup postgres database. Instructions can be found 
[here](http://www.postgresql.org/docs/9.4/static/sql-createdatabase.html 'http://www.postgresql.org/docs/9.4/static/sql-createdatabase.html').

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;By default database name is `` sit ``, role name is `` vlad ``, and its password `` 123 ``. 
You need to create database and role with this parameters, or create custom database and role and set its parameters to ``  config/database.yml `` project file, in development and production sections. 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install bundler gem:  
  `` gem install bundler ``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install gems:  
  `` bundle install ``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Run migrations:  
  `` rake db:migrate ``  
  `` rake db:seed ``  
  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In `` config/environments/development.rb `` and `` config/environments/production.rb `` files, you need to specify gmail accout and use it as smtp server. Settings can be found in block:  
`` config.action_mailer.smtp_settings = { ``  
``        :address              => "smtp.gmail.com", ``  
``        :port                 => 587,  ``  
``        :domain               => "gmail.com",  ``  
``        :user_name            => "login",  ``  
``        :password             => "password",  ``   
``        :authentication       => "plain",  ``  
``        :enable_starttls_auto => true  ``  
``    }   ``  

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To start application go to `` /bin `` in project directory and type in console:

`` rails server -b 127.0.0.1 -p 3000 -e production  ``  

You can also type development instead of production. Or if you use RubyMine start app from it by running one of configurations: development of production.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;App can be accessed on link: http://127.0.0.1:3000

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Admin section locates on this link: http://127.0.0.1:3000/admin

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Login: `` admin ``  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Password: `` 123 ``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In this section you can add or change created users, tickets, ticket statuses and departments, and response to the tickets.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Also you can create new tickets as customer on main page.
