# RoleFu #

RoleFu is a Rails plugin that enables role-base authorization via a generator script and simple controller configuration.

## Installation ##

1. Install the plugin

	script/plugin install git://github.com/brentmc79/role_fu.git

2. Generate the migration

	script/generate role_fu
	
	If the model that you're adding roles to is something other than User, then you may want/need to change the :user_id column for RoleMapping to something else.

3. Modify your model by adding 'has_role_fu'.

		class User < ActiveRecord::Base
			has_role_fu
		end
	
		This does two things.  First it declares the associations with roles and role mappings.  Second, it provides boolean methods for each row in the Roles table.  So if there's a role with the name "author", then your model will have the method .author?

4. Modify your controllers.

		class SomeController < ApplicationController
			has_role_fu [options]
		
			def	some_action
				#do stuff
			end
		end

		Just add the has_role_fu method call somewhere in you conroller.  See the next section for configuration options.

## Configuration ##

All of the configuration happens in the controllers.  The has_role_fu method expects a hash where the keys are the action names, and the values can be one of two things:

1. An array of role names, like [:admin, :author, :editor].  This will allow admins, authors, editors, OR any of their sub-roles to perform this action.  Note that every Role can have a parent role, and/or one or more lesser roles.

2. Another hash where the key is :only and the value is an array of role names.  The difference here is that you are now explicitly specifying the acceptable roles.  In other word, ONLY the specified roles, and not any of their sub-roles, will be authorized to perform the action.

RoleFu assumes that you're using some form of authorization that exposes the active user via a "current_user" method.  You can override this by using the :user_alias option, where the value is the symbol representing the active role-owner.  

## Example ##

Given a set of roles:

* system_admin
** admin
** editor
*** author
*** reader


Copyright (c) 2009 Brent Collier, released under the MIT license
