# frozen_string_literal: true

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data = nil)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    data.size <=> other.data.size
  end
end

class Tree
  attr_accessor :sorted_array, :root

  def initialize(array)
    @sorted_array = array.sort.uniq
    @root = build_tree(@sorted_array)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.length / 2
    root_node = Node.new(array[mid])
    root_node.left = build_tree(array[0...mid])
    root_node.right = build_tree(array[mid + 1..-1])
    root_node
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│ ' : ' '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? ' ' : '│ '}", true) if node.left
  end

  def insert(root_node, insert_node)
    return root_node = insert_node if root_node.nil?

    if root_node.data < insert_node.data
      if root_node.right
        insert(root_node.right, insert_node)
      else
        root_node.right = insert_node
      end
    else
      if root_node.left
        insert(root_node.left, insert_node)
      else
        root_node.left = insert_node
      end
    end
  end

  def minimum_value_node(node)
    node = node.left until node.left.nil?
    node
  end

  def delete(node, key)
    return node unless node

    if key < node.data
      node.left = delete(node.left, key)
    elsif key > node.data
      node.right = delete(node.right, key)
    else
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      elsif node.right.nil?
        temp = node.left
        node = nil
        return temp
      end
      temp = minimum_value_node(node.right)
      node.data = temp.data
      node.right = delete(node.right, temp.data)
    end
    node
  end

  def find(node, key)
    return node if node.nil? || node.data == key

    if node.data < key
      find(node.right, key)
    else
      find(node.left, key)
    end
  end

  def height(node)
    return -1 unless node

    left_height = height(node.left)
    right_height = height(node.right)

    if left_height > right_height
      left_height + 1
    else
      right_height + 1
    end
  end

  def depth(node)
    # Write a #depth method which accepts a node and returns the depth(number of levels) beneath the node.
    # TODO: Should this be returning the distance between the root and current node? Check solutons to make sure
    return -1 unless node

    left_depth = depth(node.left)
    right_depth = depth(node.right)

    if left_depth > right_depth
      left_depth + 1
    else
      right_depth + 1
    end
  end

  def balanced?(node)
    return nil unless node

    balanced?(node.left)
    balanced?(node.right)

    (height(node.left) - height(node.right)).abs <= 1
  end

  def make_level_order_array(node)
    return nil unless node

    queue = []
    return_array = []
    queue.push(node)
    until queue.empty?
      current_node = queue[0]
      return_array << current_node.data
      queue.push(current_node.left) if current_node.left
      queue.push(current_node.right) if current_node.right
      queue.shift
    end
    return_array
  end

  def rebalance
    level_order_array = make_level_order_array(root)
    Tree.new(level_order_array.sort.uniq)
  end

  def level_order(node)
    return nil unless node

    queue = []
    queue.push(node)
    until queue.empty?
      current_node = queue[0]
      print "#{current_node.data} "
      queue.push(current_node.left) if current_node.left
      queue.push(current_node.right) if current_node.right
      queue.shift
    end
  end

  def pre_order(node)
    return nil unless node

    print "#{node.data} "
    pre_order(node.left)
    pre_order(node.right)
  end

  def in_order(node)
    return nil unless node

    in_order(node.left)
    print "#{node.data} "
    in_order(node.right)
  end

  def post_order(node)
    return nil unless node

    post_order(node.left)
    post_order(node.right)
    print "#{node.data} "
  end
end

random_numbers = Array.new(15) { rand(1..100) }
tree = Tree.new(random_numbers)
tree.pretty_print
p tree.balanced?(tree.root)
tree.level_order(tree.root)
puts '---'
tree.pre_order(tree.root)
puts '---'
tree.post_order(tree.root)
puts '---'
tree.in_order(tree.root)
puts '---'
tree.insert(tree.root, Node.new(101))
tree.insert(tree.root, Node.new(102))
tree.insert(tree.root, Node.new(103))
tree.insert(tree.root, Node.new(104))
tree.insert(tree.root, Node.new(105))
tree.insert(tree.root, Node.new(106))
tree.insert(tree.root, Node.new(107))
puts '---'
tree.pretty_print
p tree.balanced?(tree.root)
tree = tree.rebalance
puts '---'
tree.pretty_print
p tree.balanced?(tree.root)
tree.level_order(tree.root)
puts '---'
tree.pre_order(tree.root)
puts '---'
tree.post_order(tree.root)
puts '---'
tree.in_order(tree.root)
puts '---'
