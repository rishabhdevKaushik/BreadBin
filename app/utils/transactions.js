import { getValue, setValue } from "./storage";

export async function getTransactions() {
  try {
    return (await getValue("transactions")) || [];
  } catch (error) {
    return "Error while getting transactions";
  }
}

export async function addTransaction(args) {
  const transaction = {
    amount: args.amount,
    type: args.type,
    datetime: args.datetime || new Date().toISOString(),
    tags: args.tags || [],
  };

  try {
    let allTransactions = await getValue("transactions");
    allTransactions = allTransactions ? await JSON.parse(allTransactions) : [];

    allTransactions.push(transaction);
    await setValue("transactions", JSON.stringify(allTransactions));
  } catch (error) {
    console.log("Error while adding transaction:", error);
    throw new Error("Failed to add transaction");
  }
}
