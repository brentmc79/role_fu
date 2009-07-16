class Role < ActiveRecord::Base
  has_many :role_mappings
  has_many :lesser_roles, :class_name => "Role", :foreign_key => :parent_id
  belongs_to :parent, :class_name => "Role"
  
  def parent_roles
    parent.nil? ? [] : ([parent] + parent.parent_roles)
  end
  
end

class RoleMapping < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
end
  
module RoleFu
  
  module ActiveRecordHackery
  
    module ClassMethods
    
      def has_role_fu options = {}
      
        has_many :role_mappings
        has_many :roles, :through => :role_mappings
      
        Role.all.collect(&:name).each do |name|
          define_method "#{name}?" do
            role = Role.find_by_name(name)
            roles.include?(role) || (roles & role.parent_roles).any?
          end
        end
      
        include RoleFu::ActiveRecordHackery::InstanceMethods
      end
    
    end
  
    module InstanceMethods
    
    end
    
  end
  
  module ActionControllerHackery
    
    module ClassMethods
      
      def has_role_fu(options = {})
        before_filter :role_is_authorized?
        options.each_pair do |action, roles|
          raise ArgumentError.new("Invalid has_role_fu option.  Must be a hash containing only symbols or hashes.") unless roles.is_a?(Array) || roles.is_a?(Hash) || roles.is_a?(Symbol)
          #debugger
          #raise ArgumentError.new("Unknown action [#{action}] for has_role_fu options.") unless self.public_methods.include?(action)
          #raise ArgumentError.new("Unknown role for action [#{action}] in has_role_fu options.") if Role.all.collect{|r| r.name.to_sym } + [:]
        end
        self.role_requirements = options
        include RoleFu::ActionControllerHackery::InstanceMethods
      end
      
      def role_requirements
        @@role_requirements
      end
      
      def role_requirements=(arg)
        @@role_requirements = arg
      end
      
    end
    
    module InstanceMethods
      
      def role_required
        authorized_role? || authorization_denied
      end
      
      def authorized_role?
        return false unless current_user
        return true if self.class.role_requirements[action_name.to_sym].nil?
        roles = self.class.role_requirements[action_name.to_sym]
        case roles
        when Symbol
          return current_user.send(roles.to_s + "?")
        when Array
          roles.each do |role|
            return true if current_user.send(role.to_s + "?")
          end
        when Hash
          if roles[:only]
            return (current_user.roles & Role.all(:conditions => {:name => roles[:only].collect(&:to_s)})).any?
          elsif roles[:except]
            return !(current_user.roles & Role.all(:conditions => {:name => roles})).any?
          else
            raise ArgumentError.new("Invalid has_role_fu option.  Each action must map to either an array of roles, or a hash with key :only or :except.")
          end
        else
          raise ArgumentError.new("Invalid role specifications for #{controller_name}:#{action_name}")
        end
        return false
      end
      
      def authorization_denied
        redirect_back_or_default
      end
      
    end
    
  end
  
end

ActiveRecord::Base.extend RoleFu::ActiveRecordHackery::ClassMethods
ActionController::Base.extend RoleFu::ActionControllerHackery::ClassMethods
