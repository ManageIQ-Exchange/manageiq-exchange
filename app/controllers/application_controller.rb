class ApplicationController < ActionController::API
=begin
  @apiDefine Pagination Pagination
  @apiSuccess {Object} meta Metadata
  @apiSuccess {Integer} meta.current_page Current page in pagination
  @apiSuccess {Integer} meta.total_pages Total number of pages
  @apiSuccess {Integer} meta.total_count Total number of elements
=end

=begin
@apiDefine NoContent No Content
@apiSuccess (No Content 204) NoContent Response has no content
=end

=begin
@apiDefine user User Authentication Needed
=end

end
