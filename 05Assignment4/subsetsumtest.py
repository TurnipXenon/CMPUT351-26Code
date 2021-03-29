# Returns true if there exists a subsequence of `A[0…n]` with the given sum
def subsetSum(A, n, sum):
 
    # return true if the sum becomes 0 (subset found)
    if sum == 0:
        return True
 
    # base case: no items left, or sum becomes negative
    if n < 0 or sum < 0:
        return False
 
    # Case 1. Include the current item `A[n]` in the subset and recur
    # for the remaining items `n-1` with the remaining total `sum-A[n]`
    include = subsetSum(A, n - 1, sum - A[n])
 
    # Case 2. Exclude the current item `A[n]` from the subset and recur for
    # the remaining items `n-1`
    exclude = subsetSum(A, n - 1, sum)
 
    # return true if we can get subset by including or excluding the
    # current item
    return include or exclude
 
 
# Subset Sum Problem
if __name__ == '__main__':
 
    # Input: a set of items and a sum
    A = [73126254, 682039078, 697267134, 2806596278, 2044349838,
           1818198982, 1432982238, 3234586198, 816273326, 312522342,
           4193226750, 4054437878, 138219470, 3100462854, 1779338014,
           411350934, 2579731950, 2628644262, 447849534, 3186898230]
    sum = 7450443154
 
    if subsetSum(A, len(A) - 1, sum):
        print("Subsequence with the given sum exists")
    else:
        print("Subsequence with the given sum does not exist")