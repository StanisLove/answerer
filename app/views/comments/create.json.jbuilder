json.(@comment, :id, :body, :created_at, :commentable_id)
json.commentable_type @comment.commentable_type.downcase
json.user_email @comment.user.email
