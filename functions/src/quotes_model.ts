export class QuotesModel{
    author: string;
    quote: string;
    category: string;
    constructor(author: string, quote: string, category: string){
        this.author = author;
        this.quote = quote;
        this.category = category;
    }
    static fromJson(json: any): QuotesModel{
        const author = json["author"];
        const quote = json["quote"];
        const category = json["category"];
        return new QuotesModel(author, quote, category);
    }
    toJson(): any{
        return {
            "author": this.author,
            "quote": this.quote,
            "category": this.category,
        };
    }

}