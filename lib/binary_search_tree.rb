# frozen_string_literal: true

require 'pry-byebug'
# binary tree node
class Node
  attr_accessor :left, :right, :value

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end
end

# create binary search tree
class Tree
  attr_reader :root

  def initialize(arr)
    @arr = arr
    @root = build_tree(@arr, 0, @arr.length - 1)
    # queue to keep track of discovered nodes
    @queued_nodes = []
    # keep track of visited nodes
    @visited_nodes = []
    # store preorder arr
    @preorder_arr = []
    # store inorder arr
    @inorder_arr = []
    # store postorder arr
    @postorder_arr = []
  end

  # convert sorted array to balanced BST
  # input: sorted array
  # output: root node of balanced BST
  def build_tree(arr, t_start, t_end)
    return if arr.class != Array

    return if t_start > t_end

    # find middle index of arr
    mid = (t_start + t_end) / 2

    # make middle element root
    root = Node.new(arr[mid])

    # assign all values < mid to left of subtree
    root.left = build_tree(arr, t_start, mid - 1)

    # assign all values > mid to right of subtree
    root.right = build_tree(arr, mid + 1, t_end)

    # return root element
    root
  end

  # insert a value into binary search tree
  def insert(value, root = @root)
    # if tree is empty,
    # return new node
    if root.nil?
      root = Node.new(value)
      root
    end

    # else, look down the tree
    if value < root.value
      root.left = insert(value, root.left)
    elsif value > root.value
      root.right = insert(value, root.right)
    end

    # return node pointer
    root
  end

  # if search tree is not empty
  # return node with minimum val

  def min_val_node(node)
    current = node

    current = current.left while (current.left.nil? == false)

    current
  end

  def delete(value, root = @root)
    # if tree is empty,
    # return new node
    root if root.nil?

    # else, look down the tree
    if value < root.value
      root.left = delete(value, root.left)
    elsif value > root.value
      root.right = delete(value, root.right)

    # if value == root, lets delete it
    else
      # check if node has one child
      # if so, replace with child
      if root.left.nil?
        temp = root.right
        root = nil
        return temp
      elsif root.right.nil?
        temp = root.left
        root = nil
        return temp
      end

      # if node has two children
      # find next biggest by looking in right subtree
      # and replace with first leftmost child
      # if no left node smaller, replace with smallest found

      temp = min_val_node(root.right)

      root.value = temp.value

      root.right = delete(temp.value, root.right)
    end

    # return node pointer
    root
  end

  # find and return value in tree
  def find(value, root = @root)

    current = root.clone
    # if node empty,
    # end of tree reached. move on to next node in tree
    current if current.nil?

    # look down the tree
    if value < current.value
      current.left = find(value, current.left)
    elsif value > current.value
      current.right = find(value, current.right)
    # if current.value == value
    else
      # return node
      current
    end
  end

  # traverse the tree in breadth first level order
  # yield each node the provided block
  # return array of values if no block given
  # store values already traversed in array
  def level_order(root = @root, queued_nodes = @queued_nodes, visited_nodes = @visited_nodes)
    return if root.nil?

    # perform block operation on current node, print result

    # loop version
    queued_nodes.push(root)

    while queued_nodes.empty? == false
      current = queued_nodes.first
      visited_nodes.push(current.value)

      p yield current.value if block_given?

      queued_nodes.push(current.left) if current.left.nil? == false
      queued_nodes.push(current.right) if current.right.nil? == false

      queued_nodes.shift
    end

    return unless block_given? == false

    puts visited_nodes

  end

  #traverse tree in preorder
  def preorder(root = @root)
    return if root.nil?
    p root.value
    preorder(root.left)
    preorder(root.right)
  end 

  def inorder(root=@root)
    return if root.nil?
    inorder(root.left)
    p root.value
    inorder(root.right)
  end

  def postorder(root=@root)
    return if root.nil?
    postorder(root.left)
    postorder(root.right)
    p root.value
  end

  # number of edges from given node to leaf node
  def height(node = root)
    return -1 if node.nil?

    # get height of left tree
    l_height = height(node.left)
    # get height of right tree
    r_height = height(node.right)
  
    # return greater of two heights
    return [l_height, r_height].max + 1
  end

  # number of edges from root to given node
  def depth(node = root)
    return -1 if node.nil?

    l_depth = depth(node.left)

    r_depth = depth(node.right)

    return [l_depth, r_depth].max + 1
  end

  # check if BFS is balanced
  def balanced?(node = root)
    l_height = self.height(node.left)
    r_height = self.height(node.right)

    puts 'abs:'
    p (l_height - r_height).abs
    # absolute value between two values
    # is abs less than or equal to 1?
    (l_height - r_height).abs <= 1 ? true : false 
  end

  # print out search tree
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

arr = [1, 2, 3, 4, 5, 6, 7]

tree = Tree.new(arr)
tree.level_order { |e| e * 2 }
puts 'preorder:'
tree.preorder
puts 'inorder:'
tree.inorder
puts 'postorder:'
tree.postorder
puts 'height:'
p tree.height
puts "depth:"
p tree.depth
tree.insert(8)
tree.insert(10)
tree.delete(7)
tree.insert(11)
tree.pretty_print