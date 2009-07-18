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
			has_role_fu
		
			def	some_action
				#do stuff
			end
		end

to be continued...

## Configuration ##



## Example ##




Copyright (c) 2009 [name of plugin creator], released under the MIT license
