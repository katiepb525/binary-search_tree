# frozen_string_literal: true

# binary tree node
class Node
  include Comparable
  attr_accessor :left, :right, :value
  def initialize(left=nil, right=nil, value)
    @left = left
    @right = right
    @value = value
  end
end

class Tree
  def initialize(arr)
    @arr = arr
    @root = build_tree(@arr)
  end

  # convert sorted array to balanced BST
  # input: sorted array
  # output: root node of balanced BST
  def build_tree(arr)
    return if arr.class != 'Array'

    # find middle index of arr
    mid = arr.length / 2

    # make middle element root
    root = Node.new(nil, nil, arr[mid])

    # assign all values < mid to left of subtree
    root.left = build_tree(arr[mid])

    # assign all values > mid to right of subtree
    root.right = build_tree(arr[mid+1])

    # return root element
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end