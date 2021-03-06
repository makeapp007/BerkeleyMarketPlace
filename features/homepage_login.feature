# id 151972941
Feature: login and authentication 

  As a user,
  I want to login using bmail
  I can pass authentication 
  
  
Background:
  Given there is an item
  
Scenario: login user to homepage and logout
  When I go to the home page
  Then I should not see "sample item title"
  Then I login with correct normal email
  Then I should see "sample item title"
  Then I logout
  Then I should not see "sample item title"


Scenario: cannot access any other pages if not logged in
  When I go to the admin page
  Then I should not see "Statistics"
  And I should see "LOGIN WITH BMAIL"
  
  
Scenario: cannot login with non berkeley email
  When I go to the home page
  Then I login with incorrect email
  Then I should not see "sample item"
  And I should see "please login with @berkeley.edu email"