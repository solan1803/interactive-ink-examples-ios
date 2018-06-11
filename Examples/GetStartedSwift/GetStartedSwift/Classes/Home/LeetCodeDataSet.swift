//
//  LeetCodeDataSet.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 29/05/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import Foundation

public let LEETCODE_DATA = [
    ["1", "Two Sum", "/problems/two-sum", "38.3%", "Easy", "Given an array of integers, return  indices  of the two numbers such that they add up to a specific target. \n\n You may assume that each input would have  exactly  one solution, and you may not use the  same  element twice. \n\n Example: \n\n Given nums = [2, 7, 11, 15], target = 9,\n\nBecause nums[ 0 ] + nums[ 1 ] = 2 + 7 = 9,\nreturn [ 0 ,  1 ].", "class Solution {\n    public int[] twoSum(int[] nums, int target) {\n", "\n    }\n}"],
    ["2", "Add Two Numbers", "/problems/add-two-numbers", "28.8%", "Medium", "You are given two  non-empty  linked lists representing two non-negative integers. The digits are stored in  reverse order  and each of their nodes contain a single digit. Add the two numbers and return it as a linked list. \n\n You may assume the two numbers do not contain any leading zero, except the number 0 itself. \n\n \n Example \n Input:  (2 -> 4 -> 3) + (5 -> 6 -> 4)\n Output:  7 -> 0 -> 8\n Explanation:  342 + 465 = 807.", "/**\n * Definition for singly-linked list.\n * public class ListNode {\n *     int val;\n *     ListNode next;\n *     ListNode(int x) { val = x; }\n * }\n */\nclass Solution {\n    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {\n", "\n    }\n}"],
    ["3", "Longest Substring Without Repeating Characters", "/problems/longest-substring-without-repeating-characters", "24.8%", "Medium", "Given a string, find the length of the  longest substring  without repeating characters. \n\n Examples: \n\n Given  \"abcabcbb\" , the answer is  \"abc\" , which the length is 3. \n\n Given  \"bbbbb\" , the answer is  \"b\" , with the length of 1. \n\n Given  \"pwwkew\" , the answer is  \"wke\" , with the length of 3. Note that the answer must be a  substring ,  \"pwke\"  is a  subsequence  and not a substring.", "class Solution {\n    public int lengthOfLongestSubstring(String s) {\n", "\n    }\n}"],
    ["4", "Median of Two Sorted Arrays", "/problems/median-of-two-sorted-arrays", "23.3%", "Hard", "There are two sorted arrays  nums1  and  nums2  of size m and n respectively. \n\n Find the median of the two sorted arrays. The overall run time complexity should be O(log (m+n)). \n\n Example 1: \n nums1 = [1, 3]\nnums2 = [2]\n\nThe median is 2.0\n \n \n\n Example 2: \n nums1 = [1, 2]\nnums2 = [3, 4]\n\nThe median is (2 + 3)/2 = 2.5\n \n", "class Solution {\n    public double findMedianSortedArrays(int[] nums1, int[] nums2) {\n", "\n    }\n}"],
    ["5", "Longest Palindromic Substring", "/problems/longest-palindromic-substring", "25.4%", "Medium", "Given a string  s , find the longest palindromic substring in  s . You may assume that the maximum length of  s  is 1000. \n\n Example 1: \n\n Input:  \"babad\"\n Output:  \"bab\"\n Note:  \"aba\" is also a valid answer.\n \n\n Example 2: \n\n Input:  \"cbbd\"\n Output:  \"bb\"\n \n", "class Solution {\n    public String longestPalindrome(String s) {\n", "\n    }\n}"],
    ["6", "ZigZag Conversion", "/problems/zigzag-conversion", "27.6%", "Medium", "The string  \"PAYPALISHIRING\"  is written in a zigzag pattern on a given number of rows like this: (you may want to display this pattern in a fixed font for better legibility) \n\n P   A   H   N\nA P L S I I G\nY   I   R\n \n\n And then read line by line:  \"PAHNAPLSIIGYIR\" \n\n Write the code that will take a string and make this conversion given a number of rows: \n\n string convert(string s, int numRows); \n\n Example 1: \n\n Input:  s = \"PAYPALISHIRING\", numRows = 3\n Output:  \"PAHNAPLSIIGYIR\"\n \n\n Example 2: \n\n Input:  s = \"PAYPALISHIRING\", numRows =\u{00a04}\n Output: \u{00a0}\"PINALSIGYAHRPI\"\n Explanation: \n\nP     I    N\nA   L S  I G\nY A   H R\nP     I \n", "class Solution {\n    public String convert(String s, int numRows) {\n", "\n    }\n}"],
    ["7", "Reverse Integer", "/problems/reverse-integer", "24.4%", "Easy", "Given a 32-bit signed integer, reverse digits of an integer. \n\n Example 1: \n\n Input:  123\n Output:  321\n \n\n Example 2: \n\n Input:  -123\n Output:  -321\n \n\n Example 3: \n\n Input:  120\n Output:  21\n \n\n Note: \nAssume we are dealing with an environment which could only store integers within the 32-bit signed integer range: [\u{22122} 31 ,\u{00a0} 2 31\u{00a0} \u{2212} 1]. For the purpose of this problem, assume that your function returns 0 when the reversed integer overflows. \n", "class Solution {\n    public int reverse(int x) {\n", "\n    }\n}"],
    ["8", "String to Integer (atoi)", "/problems/string-to-integer-atoi", "14.1%", "Medium", "Implement  atoi  which\u{00a0}converts a string to an integer. \n\n The function first discards as many whitespace characters as necessary until the first non-whitespace character is found. Then, starting from this character, takes an optional initial plus or minus sign followed by as many numerical digits as possible, and interprets them as a numerical value. \n\n The string can contain additional characters after those that form the integral number, which are ignored and have no effect on the behavior of this function. \n\n If the first sequence of non-whitespace characters in str is not a valid integral number, or if no such sequence exists because either str is empty or it contains only whitespace characters, no conversion is performed. \n\n If no valid conversion could be performed, a zero value is returned. \n\n Note: \n\n \n\t Only the space character  ' '  is considered as whitespace character. \n\t Assume we are dealing with an environment which could only store integers within the 32-bit signed integer range: [\u{22122} 31 ,\u{00a0} 2 31\u{00a0} \u{2212} 1]. If the numerical value is out of the range of representable values, INT_MAX (2 31\u{00a0} \u{2212} 1) or INT_MIN (\u{22122} 31 ) is returned. \n \n\n Example 1: \n\n Input:  \"42\"\n Output:  42\n \n\n Example 2: \n\n Input:  \"   -42\"\n Output:  -42\n Explanation:  The first non-whitespace character is '-', which is the minus sign.\n\u{00a0}            Then take as many numerical digits as possible, which gets 42.\n \n\n Example 3: \n\n Input:  \"4193 with words\"\n Output:  4193\n Explanation:  Conversion stops at digit '3' as the next character is not a numerical digit.\n \n\n Example 4: \n\n Input:  \"words and 987\"\n Output:  0\n Explanation:  The first non-whitespace character is 'w', which is not a numerical \n\u{00a0}            digit or a +/- sign. Therefore no valid conversion could be performed. \n\n Example 5: \n\n Input:  \"-91283472332\"\n Output:  -2147483648\n Explanation:  The number \"-91283472332\" is out of the range of a 32-bit signed integer.\n\u{00a0}            Thefore INT_MIN (\u{22122} 31 ) is returned. \n", "class Solution {\n    public int myAtoi(String str) {\n", "\n    }\n}"],
    ["9", "Palindrome Number", "/problems/palindrome-number", "36.5%", "Easy", "Determine whether an integer is a palindrome. An integer\u{00a0}is\u{00a0a}\u{00a0}palindrome when it\u{00a0}reads the same backward as forward. \n\n Example 1: \n\n Input:  121\n Output:  true\n \n\n Example 2: \n\n Input:  -121\n Output:  false\n Explanation:  From left to right, it reads -121. From right to left, it becomes 121-. Therefore it is not a palindrome.\n \n\n Example 3: \n\n Input:  10\n Output:  false\n Explanation:  Reads 01 from right to left. Therefore it is not a palindrome.\n \n\n Follow up: \n\n Coud you solve\u{00a0}it without converting the integer to a string? \n", "class Solution {\n    public boolean isPalindrome(int x) {\n", "\n    }\n}"],
    ["10", "Regular Expression Matching", "/problems/regular-expression-matching", "24.3%", "Hard", "Given an input string ( s ) and a pattern ( p ), implement regular expression matching with support for  '.'  and  '*' . \n\n '.' Matches any single character.\n'*' Matches zero or more of the preceding element.\n \n\n The matching should cover the  entire  input string (not partial). \n\n Note: \n\n \n\t s \u{00a0}could be empty and contains only lowercase letters  a-z . \n\t p  could be empty and contains only lowercase letters  a-z , and characters like\u{00a0} . \u{00a0}or\u{00a0} * . \n \n\n Example 1: \n\n Input: \ns = \"aa\"\np = \"a\"\n Output:  false\n Explanation:  \"a\" does not match the entire string \"aa\".\n \n\n Example 2: \n\n Input: \ns = \"aa\"\np = \"a*\"\n Output:  true\n Explanation: \u{00a0}'*' means zero or more of the precedeng\u{00a0}element, 'a'. Therefore, by repeating 'a' once, it becomes \"aa\".\n \n\n Example 3: \n\n Input: \ns = \"ab\"\np = \".*\"\n Output:  true\n Explanation: \u{00a0}\".*\" means \"zero or more (*) of any character (.)\".\n \n\n Example 4: \n\n Input: \ns = \"aab\"\np = \"c*a*b\"\n Output:  true\n Explanation: \u{00a0}c can be repeated 0 times, a can be repeated 1 time. Therefore it matches \"aab\".\n \n\n Example 5: \n\n Input: \ns = \"mississippi\"\np = \"mis*is*p*.\"\n Output:  false\n \n", "class Solution {\n    public boolean isMatch(String s, String p) {\n", "\n    }\n}"],
    ["11", "Container With Most Water", "/problems/container-with-most-water", "37.2%", "Medium", "Given  n  non-negative integers  a 1 ,  a 2 , ...,  a n , where each represents a point at coordinate ( i ,  a i ).  n  vertical lines are drawn such that the two endpoints of line  i  is at ( i ,  a i ) and ( i , 0). Find two lines, which together with x-axis forms a container, such that the container contains the most water.\n \n Note: You may not slant the container and  n  is at least 2.\n", "class Solution {\n    public int maxArea(int[] height) {\n", "\n    }\n}"],
    ["12", "Integer to Roman", "/problems/integer-to-roman", "46.7%", "Medium", "Roman numerals are represented by seven different symbols:\u{00a0} I ,  V ,  X ,  L ,  C ,  D  and  M . \n\n Symbol         Value \nI             1\nV             5\nX             10\nL             50\nC             100\nD             500\nM             1000 \n\n For example,\u{00a0}two is written as  II \u{00a0}in Roman numeral, just two one's added together. Twelve is written as,  XII , which is simply  X  +  II . The number twenty seven is written as  XXVII , which is  XX  +  V  +  II . \n\n Roman numerals are usually written largest to smallest from left to right. However, the numeral for four is not  IIII . Instead, the number four is written as  IV . Because the one is before the five we subtract it making four. The same principle applies to the number nine, which is written as  IX . There are six instances where subtraction is used: \n\n \n\t I  can be placed before  V  (5) and  X  (10) to make 4 and 9.\u{00a0} \n\t X  can be placed before  L  (50) and  C  (100) to make 40 and 90.\u{00a0} \n\t C  can be placed before  D  (500) and  M  (1000) to make 400 and 900. \n \n\n Given an integer, convert it to a roman numeral. Input is guaranteed to be within the range from 1 to 3999. \n\n Example 1: \n\n Input: \u{00a0}3\n Output:  \"III\" \n\n Example 2: \n\n Input: \u{00a0}4\n Output:  \"IV\" \n\n Example 3: \n\n Input: \u{00a0}9\n Output:  \"IX\" \n\n Example 4: \n\n Input: \u{00a0}58\n Output:  \"LVIII\"\n Explanation:  C = 100, L = 50, XXX = 30 and III = 3.\n \n\n Example 5: \n\n Input: \u{00a0}1994\n Output:  \"MCMXCIV\"\n Explanation:  M = 1000, CM = 900, XC = 90 and IV = 4. \n", "class Solution {\n    public String intToRoman(int num) {\n", "\n    }\n}"],
    ["13", "Roman to Integer", "/problems/roman-to-integer", "48.5%", "Easy", "Roman numerals are represented by seven different symbols:\u{00a0} I ,  V ,  X ,  L ,  C ,  D  and  M . \n\n Symbol         Value \nI             1\nV             5\nX             10\nL             50\nC             100\nD             500\nM             1000 \n\n For example,\u{00a0}two is written as  II \u{00a0}in Roman numeral, just two one's added together. Twelve is written as,  XII , which is simply  X  +  II . The number twenty seven is written as  XXVII , which is  XX  +  V  +  II . \n\n Roman numerals are usually written largest to smallest from left to right. However, the numeral for four is not  IIII . Instead, the number four is written as  IV . Because the one is before the five we subtract it making four. The same principle applies to the number nine, which is written as  IX . There are six instances where subtraction is used: \n\n \n\t I  can be placed before  V  (5) and  X  (10) to make 4 and 9.\u{00a0} \n\t X  can be placed before  L  (50) and  C  (100) to make 40 and 90.\u{00a0} \n\t C  can be placed before  D  (500) and  M  (1000) to make 400 and 900. \n \n\n Given a roman numeral, convert it to an integer. Input is guaranteed to be within the range from 1 to 3999. \n\n Example 1: \n\n Input: \u{00a0}\"III\"\n Output:  3 \n\n Example 2: \n\n Input: \u{00a0}\"IV\"\n Output:  4 \n\n Example 3: \n\n Input: \u{00a0}\"IX\"\n Output:  9 \n\n Example 4: \n\n Input: \u{00a0}\"LVIII\"\n Output:  58\n Explanation:  C = 100, L = 50, XXX = 30 and III = 3.\n \n\n Example 5: \n\n Input: \u{00a0}\"MCMXCIV\"\n Output:  1994\n Explanation:  M = 1000, CM = 900, XC = 90 and IV = 4. \n", "class Solution {\n    public int romanToInt(String s) {\n", "\n    }\n}"],
    ["14", "Longest Common Prefix", "/problems/longest-common-prefix", "31.7%", "Easy", "Write a function to find the longest common prefix string amongst an array of strings. \n\n If there is no common prefix, return an empty string  \"\" . \n\n Example 1: \n\n Input:  [\"flower\",\"flow\",\"flight\"]\n Output:  \"fl\"\n \n\n Example 2: \n\n Input:  [\"dog\",\"racecar\",\"car\"]\n Output:  \"\"\n Explanation:  There is no common prefix among the input strings.\n \n\n Note: \n\n All given inputs are in lowercase letters  a-z . \n", "class Solution {\n    public String longestCommonPrefix(String[] strs) {\n", "\n    }\n}"],
    ["15", "3Sum", "/problems/3sum", "21.8%", "Medium", "Given an array  nums  of  n  integers, are there elements  a ,  b ,  c  in  nums  such that  a  +  b  +  c  = 0? Find all unique triplets in the array which gives the sum of zero. \n\n Note: \n\n The solution set must not contain duplicate triplets. \n\n Example: \n\n Given array nums = [-1, 0, 1, 2, -1, -4],\n\nA solution set is:\n[\n  [-1, 0, 1],\n  [-1, -1, 2]\n]\n \n", "class Solution {\n    public List<List<Integer>> threeSum(int[] nums) {\n", "\n    }\n}"],
    ["16", "3Sum Closest", "/problems/3sum-closest", "31.9%", "Medium", "Given an array  nums  of  n  integers and an integer  target , find three integers in  nums \u{00a0}such that the sum is closest to\u{00a0} target . Return the sum of the three integers. You may assume that each input would have exactly one solution. \n\n Example: \n\n Given array nums = [-1, 2, 1, -4], and target = 1.\n\nThe sum that is closest to the target is 2. (-1 + 2 + 1 = 2).\n \n", "class Solution {\n    public int threeSumClosest(int[] nums, int target) {\n", "\n    }\n}"],
    ["17", "Letter Combinations of a Phone Number", "/problems/letter-combinations-of-a-phone-number", "37.0%", "Medium", "Given a string containing digits from  2-9  inclusive, return all possible letter combinations that the number could represent. \n\n A mapping of digit to letters (just like on the telephone buttons) is given below. Note that 1 does not map to any letters. \n\n \n\n Example: \n\n Input:  \"23\"\n Output:  [\"ad\", \"ae\", \"af\", \"bd\", \"be\", \"bf\", \"cd\", \"ce\", \"cf\"].\n \n\n Note: \n\n Although the above answer is in lexicographical order, your answer could be in any order you want. \n", "class Solution {\n    public List<String> letterCombinations(String digits) {\n", "\n    }\n}"],
    ["18", "4Sum", "/problems/4sum", "27.8%", "Medium", "Given an array  nums  of  n  integers and an integer  target , are there elements  a ,  b ,  c , and  d  in  nums  such that  a  +  b  +  c  +  d  =  target ? Find all unique quadruplets in the array which gives the sum of  target . \n\n Note: \n\n The solution set must not contain duplicate quadruplets. \n\n Example: \n\n Given array nums = [1, 0, -1, 0, -2, 2], and target = 0.\n\nA solution set is:\n[\n  [-1,  0, 0, 1],\n  [-2, -1, 1, 2],\n  [-2,  0, 0, 2]\n]\n \n", "class Solution {\n    public List<List<Integer>> fourSum(int[] nums, int target) {\n", "\n    }\n}"],
    ["19", "Remove Nth Node From End of List", "/problems/remove-nth-node-from-end-of-list", "33.9%", "Medium", "Given a linked list, remove the  n -th node from the end of list and return its head. \n\n Example: \n\n Given linked list:  1->2->3->4->5 , and  n  = 2 .\n\nAfter removing the second node from the end, the linked list becomes  1->2->3->5 .\n \n\n Note: \n\n Given  n  will always be valid. \n\n Follow up: \n\n Could you do this in one pass? \n", "/**\n * Definition for singly-linked list.\n * public class ListNode {\n *     int val;\n *     ListNode next;\n *     ListNode(int x) { val = x; }\n * }\n */\nclass Solution {\n    public ListNode removeNthFromEnd(ListNode head, int n) {\n", "\n    }\n}"],
    ["20", "Valid Parentheses", "/problems/valid-parentheses", "34.2%", "Easy", "Given a string containing just the characters  '(' ,  ')' ,  '{' ,  '}' ,  '['  and  ']' , determine if the input string is valid. \n\n An input string is valid if: \n\n \n\t Open brackets must be closed by the same type of brackets. \n\t Open brackets must be closed in the correct order. \n \n\n Note that an empty string is\u{00a0}also considered valid. \n\n Example 1: \n\n Input:  \"()\"\n Output:  true\n \n\n Example 2: \n\n Input:  \"()[]{}\"\n Output:  true\n \n\n Example 3: \n\n Input:  \"(]\"\n Output:  false\n \n\n Example 4: \n\n Input:  \"([)]\"\n Output:  false\n \n\n Example 5: \n\n Input:  \"{[]}\"\n Output:  true\n \n", "class Solution {\n    public boolean isValid(String s) {\n", "\n    }\n}"],
    ["21", "Merge Two Sorted Lists", "/problems/merge-two-sorted-lists", "41.8%", "Easy", "Merge two sorted linked lists and return it as a new list. The new list should be made by splicing together the nodes of the first two lists. \n\n Example: \n Input:  1->2->4, 1->3->4\n Output:  1->1->2->3->4->4\n \n", "/**\n * Definition for singly-linked list.\n * public class ListNode {\n *     int val;\n *     ListNode next;\n *     ListNode(int x) { val = x; }\n * }\n */\nclass Solution {\n    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {\n", "\n    }\n}"],
    ["22", "Generate Parentheses", "/problems/generate-parentheses", "48.7%", "Medium", "\nGiven  n  pairs of parentheses, write a function to generate all combinations of well-formed parentheses.\n \n\n \nFor example, given  n  = 3, a solution set is:\n \n [\n  \"((()))\",\n  \"(()())\",\n  \"(())()\",\n  \"()(())\",\n  \"()()()\"\n]\n", "class Solution {\n    public List<String> generateParenthesis(int n) {\n", "\n    }\n}"],
    ["23", "Merge k Sorted Lists", "/problems/merge-k-sorted-lists", "28.8%", "Hard", "Merge  k  sorted linked lists and return it as one sorted list. Analyze and describe its complexity. \n\n Example: \n\n Input: \n[\n\u{00a0} 1->4->5,\n\u{00a0} 1->3->4,\n\u{00a0} 2->6\n]\n Output:  1->1->2->3->4->4->5->6\n \n", "/**\n * Definition for singly-linked list.\n * public class ListNode {\n *     int val;\n *     ListNode next;\n *     ListNode(int x) { val = x; }\n * }\n */\nclass Solution {\n    public ListNode mergeKLists(ListNode[] lists) {\n", "\n    }\n}"],
    ["24", "Swap Nodes in Pairs", "/problems/swap-nodes-in-pairs", "39.6%", "Medium", "Given a\u{00a0}linked list, swap every two adjacent nodes and return its head. \n\n Example: \n\n Given  1->2->3->4 , you should return the list as  2->1->4->3 . \n\n Note: \n\n \n\t Your algorithm should use only constant extra space. \n\t You may  not  modify the values in the list's nodes, only nodes itself may be changed. \n \n", "/**\n * Definition for singly-linked list.\n * public class ListNode {\n *     int val;\n *     ListNode next;\n *     ListNode(int x) { val = x; }\n * }\n */\nclass Solution {\n    public ListNode swapPairs(ListNode head) {\n", "\n    }\n}"],
    ["25", "Reverse Nodes in k-Group", "/problems/reverse-nodes-in-k-group", "32.2%", "Hard", "Given a linked list, reverse the nodes of a linked list  k  at a time and return its modified list. \n\n k  is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of  k  then left-out nodes in the end should remain as it is. \n\n \n \n\n Example: \n\n Given this linked list:  1->2->3->4->5 \n\n For  k  = 2, you should return:  2->1->4->3->5 \n\n For  k  = 3, you should return:  3->2->1->4->5 \n\n Note: \n\n \n\t Only constant extra memory is allowed. \n\t You may not alter the values in the list's nodes, only nodes itself may be changed. \n \n", "/**\n * Definition for singly-linked list.\n * public class ListNode {\n *     int val;\n *     ListNode next;\n *     ListNode(int x) { val = x; }\n * }\n */\nclass Solution {\n    public ListNode reverseKGroup(ListNode head, int k) {\n", "\n    }\n}"],
]
