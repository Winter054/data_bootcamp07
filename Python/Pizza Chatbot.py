## HW01: Pizza Chatbot

# Make price to calculate price
# Make chatbot talkative 
def chatbot():
    print("""
    Welcome to our Papa Pizza!
    Please order by enter [A.] to order menu in set A.
    Menu:
    A. Solo set: Pizza + Chicken wings for 200.-
    B. Duo set: 2 Pizza + Chicken wings + Curly fries for 400.-
    C. Party set: 3 Pizza + Chicken wings + Curly fries + Garlc bread for 600.-
    D. Italiano set: Spaghetti + Garlic bread for 200.-
    Please enter 'Exit' to quit.""")

    orders = []
    price = 0
    while True:
        order = str( input("""
        What do you want to order? """))
        if order == "Exit":
            print("Your order is set", orders)
            print("That would be total $", price)
            print("Thanks for coming, have a nice day!")
            break
        elif order == "A.":
            print("You have ordered set A.")
            price += 200
            print("That would be total $", price)
        elif order == "B.":
            print("You have ordered set B.")
            price += 400
            print("That would be total $", price)
        elif order == "C.":
            print("You have ordered set C.")
            price += 600
            print("That would be total$", price)
        elif order == "D.":
            print("You have ordered set D.")
            price += 200
            print("That would be total$", price)
        orders.append(order)