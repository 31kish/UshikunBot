require "./post.rb"

def start
  $post = Post.new
  $post.recycleDay()
end

start
