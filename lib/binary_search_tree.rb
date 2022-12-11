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