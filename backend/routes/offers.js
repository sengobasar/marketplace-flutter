const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const Offer = require('../models/offer');
const Product = require('../models/Product');

const auth = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ message: 'No token' });
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.userId = decoded.userId;
        next();
    } catch {
        res.status(401).json({ message: 'Invalid token' });
    }
};

// Make an offer
router.post('/', auth, async (req, res) => {
    try {
        const { productId, offerPrice, buyerName } = req.body;

        const product = await Product.findById(productId);
        if (!product) return res.status(404).json({ message: 'Product not found' });

        const offer = new Offer({
            productId,
            buyerId: req.userId,
            sellerId: product.sellerId,
            buyerName,
            offerPrice
        });

        await offer.save();
        res.status(201).json(offer);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Get offers for a seller
router.get('/my-offers', auth, async (req, res) => {
    try {
        const offers = await Offer.find({ sellerId: req.userId })
            .populate('productId', 'title imageUrl price')
            .sort({ createdAt: -1 });
        res.json(offers);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Accept or reject offer
router.patch('/:id', auth, async (req, res) => {
    try {
        const { status } = req.body;
        const offer = await Offer.findById(req.params.id);
        if (!offer) return res.status(404).json({ message: 'Not found' });

        offer.status = status;
        await offer.save();
        res.json(offer);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;