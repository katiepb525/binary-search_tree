
# binary tree node
class Node
  include Comparable

  def initialize()
    @l_child
    @r_child
    @value
  end
  
end


class Tree
  def initialize(arr)
    @arr = arr
    @root = build_tree
  end 
  
  # convert sorted array to balanced BST
  # input: sorted array
  # output: root node of balanced BST
  def build_tree
    if @arr.class != 'Array'
      return 
    end
  end

end