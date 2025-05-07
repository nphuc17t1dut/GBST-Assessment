import { LightningElement, api } from 'lwc';

export default class AccountSidePanelLWC extends LightningElement {
    @api recordId;
    showModal = false;

    connectedCallback() {
        console.log('record id', this.recordId);
    }

    handleShowModal() {
        this.showModal = true;
    }

    handleHideModal() {
        this.showModal = false;
    }
}