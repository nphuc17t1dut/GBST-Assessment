import { LightningElement, api, track, wire } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
import deleteAllOpportunities from '@salesforce/apex/OpportunityController.deleteAllOpportunities';
import createOpportunities from '@salesforce/apex/OpportunityController.createOpportunities';
import updateAccountName from '@salesforce/apex/OpportunityController.updateAccountName';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from "lightning/uiRecordApi";

import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
const FIELDS = [ACCOUNT_NAME_FIELD];

export default class AccountModal extends LightningElement {
    @api recordId;
    @track accountName;
    @track opportunities;
    isLoading = false;

    columns = [
        { label: 'Opportunity Name', fieldName: 'Name', type: 'text' },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: { year: 'numeric', month: 'numeric', day: 'numeric' }},
        { label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date', typeAttributes: { year: 'numeric', month: 'numeric', day: 'numeric' }},
        { label: 'Days Has Passed', fieldName: 'DaysHasPassed', type: 'number' }
    ];

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    getAccount( {error, data} ) {
        if(data) {
           this.accountName = data.fields.Name.value;
        }
    }

    connectedCallback() {
        this.loadOpportunities();
    }

    handleInputChange(event) {
        this.accountName = event.target.value;
    }

    loadOpportunities() {
        this.isLoading = true;

        getOpportunities({ accountId: this.recordId })
        .then(result => {
            result.map(opportunity => {
                opportunity.DaysHasPassed = Math.floor((new Date(opportunity.CreatedDate)  - new Date('01/01/2020')) / (1000 * 60 * 60 * 24));
            })

            this.opportunities = result;
        })
        .finally(() => {
            this.isLoading = false;
        })
    }

    deleteOpportunities() {
        deleteAllOpportunities({ accountId: this.recordId })
        .then(() => {
            this.showToast('Success', 'All opportunities deleted.', 'success');
            this.loadOpportunities();
        })
        .catch(error => {
            this.showToast('Error', error.message, 'error');
        })
    }

    createOpportunities() {
        createOpportunities({ accountId: this.recordId })
        .then(() => {
            this.showToast('Success', 'Create opportunities successfully.', 'success');
            this.loadOpportunities();
        }).catch(error => {
            this.showToast('Error', error.message, 'error');
        })
    }

    handleSaveName() {
        updateAccountName({
            accountId: this.recordId,
            updateName: this.accountName
        }).then(result => {
            this.showToast('Success', 'Account Name has been updated successfully.', 'success');
        }).catch(error => {
            this.showToast('Error', error.message, 'error');
        })
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(evt);
    }

    closeModal() {
        this.dispatchEvent(new CustomEvent('closemodal'))
    }
}