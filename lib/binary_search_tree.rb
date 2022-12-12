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
  def insert(root, value)
    # if tree is empty,
    # return new node
    if root.nil?
      root = Node.new(value)
      root
    end

    # else, look down the tree
    if value < root.value
      root.left = insert(root.left, value)
    elsif value > root.value
      root.right = insert(root.right, value)
    end

    # return node pointer
    root
  end

  # if search tree is not empty
  # return node with minimum val

  def minValNode(node)
    current = node

    while(current.left.nil? == false)
      current = current.left
    end

    current
  end

  def delete(root, value)
    # if tree is empty,
    # return new node
    if root.nil?
      root
    end

    # else, look down the tree
    if value < root.value
      root.left = delete(root.left, value)
    elsif value > root.value
      root.right = delete(root.right, value)
    
    # if value == root, lets delete it
    else
      # check if node has one child
      # if so, replace with child 
      if root.left.nil?
        temp = root.right
        root =  nil
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
      
      temp = minValNode(root.right)

      root.value = temp.value

      root.right = delete(root.right, temp.value)
    end

    # return node pointer
    root
  end

  #find and return value in tree
  def find(value, root = @root)
    # if node empty,
    # end of tree reached. move on to next node in tree
    if root.nil?
      root
    end

    # look down the tree
    if value < root.value
      root.left = find(value, root.left)
    elsif value > root.value
      root.right = find(value, root.right)
    # if root.value == value
    else
      # return node
      return root
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

      if block_given?
        p yield current.value
      end

      if current.left.nil? == false
        queued_nodes.push(current.left)
      end
      if current.right.nil? == false
        queued_nodes.push(current.right)
      end

      queued_nodes.shift
    end

    if block_given? == false
      puts visited_nodes
    end
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
tree.pretty_print
tree.insert(tree.root, 8)
tree.insert(tree.root, 0)
tree.pretty_print
tree.delete(tree.root, 3)
tree.delete(tree.root, 1)
tree.pretty_print

tree.level_order{|e| e * 2}