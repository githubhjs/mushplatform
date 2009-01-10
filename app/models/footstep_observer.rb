class FootstepObserver < ActiveRecord::Observer
  observe :blog

  def after_create(record)
    if record.respond_to?(:footstep)
      record.footstep
    end
  end
  
end
