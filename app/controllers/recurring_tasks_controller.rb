class RecurringTasksController < ApplicationController
  include RecurringTasksHelper
  unloadable

  before_filter :find_recurring_task, :except => [:index, :new, :create]
  before_filter :set_interval_units, :except => [:index, :show]

  def index
    @recurring_tasks = RecurringTask.all
  end

  def show
    # default behavior is fine
  end

  def new
    @recurring_task = RecurringTask.new
  end

  # creates a new recurring task
  def create
    @recurring_task = RecurringTask.new(params[:recurring_task])
    if @recurring_task.save
      flash[:notice] = l(:recurring_task_created)
      redirect_to :action => :show, :id => @recurring_task.id
    else
      logger.debug "Could not create recurring task from #{params[:post]}"
      render :new # errors are displayed to user on form
    end
  end

  def edit
    # default behavior is fine
  end

  # saves the task and redirects to show
  def update
    if @recurring_task.update_attributes(params[:recurring_task])
      flash[:notice] = l(:recurring_task_saved)
      redirect_to :action => :show
    else
      logger.debug "Could not save recurring task #{@recurring_task}"
      render :edit # errors are displayed to user on form
    end
  end

  def destroy
    if @recurring_task.destroy
      flash[:notice] = l(:recurring_task_removed)
      redirect_to :action => :index
    else
      flash[:notice] = l(:error_recurring_task_could_not_remove)
      redirect_to :action => :show, :id => @recurring_task
    end
  end
  
private
  def find_recurring_task
    begin
      @recurring_task = RecurringTask.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      show_error "#{l(:error_recurring_task_not_found)} #{params[:id]}"
    end
  end
  
  def set_interval_units
    @interval_units = RecurringTask::INTERVAL_UNITS
  end
end
