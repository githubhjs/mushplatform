class FootstepObserver < ActiveRecord::Observer
  
  observe :blog,:user_vote,:comment
  
  def after_create(record)
    if record.respond_to?(:footstep)
      record.footstep
    end
  end
  
end
