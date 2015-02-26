class ApplicationController < ActionController::Base
  protect_from_forgery

  def index(result = nil)
    json_response(200, result || resource_class.all)
  end

  def create(&block)
    @new_resource = resource_class.new resource_params
    if @new_resource.save
      block &&  instance_exec(new_resource, &block)
      json_response 201, @new_resource
    else
      json_response 400, errors: @new_resource.errors
    end
  end

  def update(&block)
    when_resource_exists do |resource|
      if resource.update_attributes resource_params
        block &&  instance_exec(resource, &block)
        json_response 200, resource
      else
        json_response 400, errors: resource.errors
      end
    end
  end

  def show
    when_resource_exists do |resource|
      json_response 200, resource
    end
  end

  def destroy
    when_resource_exists do |resource|
      resource.destroy
      json_response 200, {status: "success"}
    end
  end

  def default_render(*args)
    super
    unless response
      empty_response
    end
    headers['Access-Control-Allow-Origin'] = '*'
  end

  protected

  def empty_response(status = 200)
    render status: status, nothing: true
  end

  def json_response(status = 200, result = {})
    render status: status, json: result.as_json
  end

  def resource_class
    controller_name.classify.constantize
  end

  def when_resource_exists
    resource = resource_class.find_by_id(params[:id])
    if resource
      yield resource
    else
      empty_response 404
    end
  end

  def resource_params(*permit_params)
    params.permit *permit_params
  end
end