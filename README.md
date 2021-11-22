# Solving the knapsack problem as an R package

This package implements three algorithms to solve the discrete optimization problem called the knapsack problem. 

Problem statement: Consider a knapsack that can take a limited weight W, and there are a number of items i = 1, ..., n each with a weight w_i and a value v_i. The goal of the algorithms is to find the combination of items that give the largest value given the weight W.

The problem is an NP-hard problem. In this package a brute force search algorithm, a greedy approximation algorithm and a dynamic programming algorithm is implemented.

## Installation

run > `devtools::install_github("https://github.com/TheodorEmanuelsson/knapsack")` in R console.

## Brute force search

This solution, `brute_force_knapsack()`, is guaranteed to give the correct optimal knapsack in all situation as the algorithm considers all possible combinations and returns the maximum value. Although precises, the solution is in efficient with complexity of O(2^n). This since all 2^n combinations are evaluated.

This algorithms supports parallel computing both on Windows and Unix-based systems.

## Greedy approximation

A simple heuristic solution, `greedy_knapsack()` to the problem with computational complexity O(n \log n). Simply computes the w_i / v_i ratio and sorts the array in descending order. Then picks out the items with the higher value one by one until W has been reached, skipping over items that do not fit.

## Dynamic solutions

This algorithm is a much more efficient solution compared to the brute force search approach and is more precise that the greedy approach. It has complexity O(Wn). The approach based on building a matrix with $n$ rows and $W$ columns where each cell represents the value gained for that item if W = 1, ..., W.
.
