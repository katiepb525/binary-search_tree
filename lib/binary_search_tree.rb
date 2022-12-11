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
    @root = build_tree(@arr, 0, @arr.length - 1)
  end

  # convert sorted array to balanced BST
  # input: sorted array
  # output: root node of balanced BST
  def build_tree(arr, t_start, t_end)

    return if arr.class != Array

    return if (t_start > t_end)

    # find middle index of arr
    mid = (t_start + t_end) / 2

    # make middle element root
    root = Node.new(nil, nil, arr[mid])

    # assign all values < mid to left of subtree
    root.left = build_tree(arr, t_start, mid - 1)

    # assign all values > mid to right of subtree
    root.right = build_tree(arr, mid + 1, t_end)

    # return root element
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

arr = [1,2,3,4,5,6,7]

tree = Tree.new(arr)
tree.pretty_print