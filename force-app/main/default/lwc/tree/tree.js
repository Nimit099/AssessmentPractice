import { LightningElement, track } from 'lwc';
import treelist from '@salesforce/apex/Querytype.treelist';

export default class Tree extends LightningElement {
    @track items = [];
    connectedCallback(){
        try {       
            treelist().then(result =>{
                result.forEach(element => {
                   console.log(element); 
                });
            })
        } catch (error) {
            console.error(error.message);
        }
    }
}