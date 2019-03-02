
#include <iostream>
using namespace std;

const int MAX = 100;



class Node {
    string identifier, type;
    bool loaded;
    Node* next;

public:
    Node(){
        next = NULL;
    }

    Node(string key, string type){
        this->identifier = key;
        this->type = type;
        next = NULL;
    }
    friend class SymbolTable;
};


class SymbolTable {
    Node* head[MAX];

public:
    SymbolTable()
    {
        for (int i = 0; i < MAX; i++)
            head[i] = NULL;
    }
    int hashfun(string id); // hash function
    bool insert(string id, string Type);
    bool find(string id);
    string checkType(string id);
    bool loadVinReg(string id);
    bool checkLoaded(string id);

};


bool SymbolTable::find(string id){
    int index = hashfun(id);
    Node* rowInTable = head[index];
    if (rowInTable == NULL)
        return false;
    while (rowInTable != NULL) {
        if (rowInTable->identifier == id) {
            return true;
        }
        rowInTable = rowInTable->next;
    }
    return false; // not found
}

string SymbolTable::checkType(string id){
    int index = hashfun(id);
    Node* rowInTable = head[index];
    if (rowInTable == NULL)
        return "-1";
    while (rowInTable != NULL) {
        if (rowInTable->identifier == id) {
            return rowInTable->type;
        }
        rowInTable = rowInTable->next;
    }
    return "-1"; // not found
}

bool SymbolTable::checkLoaded(string id){
    int index = hashfun(id);
    Node* rowInTable = head[index];
    if (rowInTable == NULL)
        return false;
    while (rowInTable != NULL) {
        if (rowInTable->identifier == id && rowInTable->loaded == true) {
            return true;
        }
        rowInTable = rowInTable->next;
    }
    return false; // not found
}

bool SymbolTable::loadVinReg(string id){
    int index = hashfun(id);
    Node* rowInTable = head[index];
    if (rowInTable == NULL)
        return false;
    while (rowInTable != NULL) {
        if (rowInTable->identifier == id) {
            rowInTable->loaded = 1;
            return true;
        }
        rowInTable = rowInTable->next;
    }
    return false; // not found
}

bool SymbolTable::insert(string id, string Type){
    int index = hashfun(id);
    Node* p = new Node(id, Type);
    if (head[index] == NULL) {
        head[index] = p;
        return true;
    }
    else {
        Node* rowInTable = head[index];
        while (rowInTable->next != NULL)
            rowInTable = rowInTable->next;
        rowInTable->next = p;
        return true;
    }
    return false;
}

int SymbolTable::hashfun(string id){
    int asciiSum = 0;
    for (int i = 0; i < id.length(); i++) {
        asciiSum = asciiSum + id[i];
    }
    return (asciiSum % 100);
}

SymbolTable st1;

// Driver code
int main()
{
    string check;
    cout << "**** SYMBOL_TABLE ****\n";
    st1.insert("a", "float");
    st1.loadVinReg("a");
    std::cout << st1.checkLoaded("a") << '\n';
    return 0;
}
